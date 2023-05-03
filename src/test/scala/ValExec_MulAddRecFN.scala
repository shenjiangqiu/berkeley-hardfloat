
/*============================================================================

This Chisel source file is part of a pre-release version of the HardFloat IEEE
Floating-Point Arithmetic Package, by John R. Hauser (with some contributions
from Yunsup Lee and Andrew Waterman, mainly concerning testing).

Copyright 2010, 2011, 2012, 2013, 2014, 2015, 2016, 2017 The Regents of the
University of California.  All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

 1. Redistributions of source code must retain the above copyright notice,
    this list of conditions, and the following disclaimer.

 2. Redistributions in binary form must reproduce the above copyright notice,
    this list of conditions, and the following disclaimer in the documentation
    and/or other materials provided with the distribution.

 3. Neither the name of the University nor the names of its contributors may
    be used to endorse or promote products derived from this software without
    specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS "AS IS", AND ANY
EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE, ARE
DISCLAIMED.  IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

=============================================================================*/

package hardfloat.test

import hardfloat._
import chisel3._

class SystolicPe(expWidth:Int,sigWidth:Int) extends Module{
    val io = IO(new Bundle{
        // the activation input
        val in_act = Input(Bits((expWidth+sigWidth+1).W))
        // the temp accumulation value
        val in_acc = Input(Bits((expWidth+sigWidth+1).W))
        // the weight input
        val in_weight = Input(Bits((expWidth+sigWidth+1).W))
        // the output of the pe
        val out = Output(Bits((expWidth+sigWidth+1).W))
    }
    )
    // the activation register
    val act_reg = RegInit(0.U((expWidth+sigWidth+1).W))
    // the accumulation register
    val acc_reg = RegInit(0.U((expWidth+sigWidth+1).W))
    // the weight register
    val weight_reg = RegInit(0.U((expWidth+sigWidth+1).W))
    // the MulAddRecFN module
    val muladd = Module(new MulAddRecFN(expWidth,sigWidth))   
    // connect the input to the register
    act_reg := io.in_act
    acc_reg := io.in_acc
    weight_reg := io.in_weight
    // connect the input to the MulAddRecFN
    muladd.io.a := act_reg
    muladd.io.b := weight_reg
    muladd.io.c := acc_reg
    muladd.io.op := 0.U
    muladd.io.roundingMode   := 0.U
    muladd.io.detectTininess := 0.U
    // connect the output of the MulAddRecFN to the output of the pe
    io.out := muladd.io.out

}

class SystolicArray(rows:Int,cols:Int,expWidth:Int,sigWidth:Int) extends Module{
    val io = IO(new Bundle{
        // the rows taks the activation values
        val in_rows = Input(Vec(rows,Bits((expWidth+sigWidth+1).W)))
        val in_cols = Input(Vec(cols,Bits((expWidth+sigWidth+1).W)))
        // each pe have a weight input 
        val weight = Input(Vec(rows*cols,Bits((expWidth+sigWidth+1).W)))
        // the output of the systolic array
        val out = Output(Vec(cols,Bits((expWidth+sigWidth+1).W)))
    })
    // the pe array
    val pe_array:Seq[Seq[SystolicPe]] = Seq.fill(rows,cols)(Module(new SystolicPe(expWidth,sigWidth)))
    // the pe array io
    // connect the weight for each pe
    for(i <- 0 until rows){
        for(j <- 0 until cols){
            pe_array(i)(j).io.in_weight := io.weight(i*cols+j)
        }
    }
    // if it's the first colunm, coonect the in_rows to the pe
    for(i <- 0 until rows){
        pe_array(i)(0).io.in_act := io.in_rows(i)
    }
    // if it's the first row, connect the in_cols to the pe
    for(j <- 0 until cols){
        pe_array(0)(j).io.in_acc := io.in_cols(j)
    }
    // for any other pe, connect the in_act to the in_acc of the pe on the left
    for(i <- 0 until rows){
        for(j <- 1 until cols){
            pe_array(i)(j).io.in_act := pe_array(i)(j-1).io.out
        }
    }
    // for any other pe, connect the in_acc to the in_act of the pe on the top
    for(i <- 1 until rows){
        for(j <- 0 until cols){
            pe_array(i)(j).io.in_acc := pe_array(i-1)(j).io.out
        }
    }
    // if it's the last row, connect the out of the pe to the out of the systolic array
    for(j <- 0 until cols){
        io.out(j) := pe_array(rows-1)(j).io.out
    }
}
class ValExec_MulAddRecFN(expWidth: Int, sigWidth: Int) extends Module
{
    val io = IO(new Bundle {
        val a = Input(Bits((expWidth + sigWidth).W))
        val b = Input(Bits((expWidth + sigWidth).W))
        val c = Input(Bits((expWidth + sigWidth).W))
        val roundingMode   = Input(UInt(3.W))
        val detectTininess = Input(UInt(1.W))

        val expected = new Bundle {
            val out = Input(Bits((expWidth + sigWidth).W))
            val exceptionFlags = Input(Bits(5.W))
            val recOut = Output(Bits((expWidth + sigWidth + 1).W))
        }

        val actual = new Bundle {
            val out = Output(Bits((expWidth + sigWidth + 1).W))
            val exceptionFlags = Output(Bits(5.W))
        }

        val check = Output(Bool())
        val pass = Output(Bool())
    })

    val mulAddRecFN = Module(new MulAddRecFN(expWidth, sigWidth))
    mulAddRecFN.io.op := 0.U
    mulAddRecFN.io.a := recFNFromFN(expWidth, sigWidth, io.a)
    mulAddRecFN.io.b := recFNFromFN(expWidth, sigWidth, io.b)
    mulAddRecFN.io.c := recFNFromFN(expWidth, sigWidth, io.c)
    mulAddRecFN.io.roundingMode   := io.roundingMode
    mulAddRecFN.io.detectTininess := io.detectTininess

    io.expected.recOut := recFNFromFN(expWidth, sigWidth, io.expected.out)

    io.actual.out := mulAddRecFN.io.out
    io.actual.exceptionFlags := mulAddRecFN.io.exceptionFlags

    io.check := true.B
    io.pass :=
        equivRecFN(expWidth, sigWidth, io.actual.out, io.expected.recOut) &&
        (io.actual.exceptionFlags === io.expected.exceptionFlags)
}

class ValExec_MulAddRecFN_add(expWidth: Int, sigWidth: Int) extends Module
{
    val io = IO(new Bundle {
        val a = Input(Bits((expWidth + sigWidth).W))
        val b = Input(Bits((expWidth + sigWidth).W))
        val roundingMode   = Input(UInt(3.W))
        val detectTininess = Input(UInt(1.W))

        val expected = new Bundle {
            val out = Input(Bits((expWidth + sigWidth).W))
            val exceptionFlags = Input(Bits(5.W))
            val recOut = Output(Bits((expWidth + sigWidth + 1).W))
        }

        val actual = new Bundle {
            val out = Output(Bits((expWidth + sigWidth + 1).W))
            val exceptionFlags = Output(Bits(5.W))
        }

        val check = Output(Bool())
        val pass = Output(Bool())
    })

    val mulAddRecFN = Module(new MulAddRecFN(expWidth, sigWidth))
    mulAddRecFN.io.op := 0.U
    mulAddRecFN.io.a := recFNFromFN(expWidth, sigWidth, io.a)
    mulAddRecFN.io.b := (BigInt(1)<<(expWidth + sigWidth - 1)).U
    mulAddRecFN.io.c := recFNFromFN(expWidth, sigWidth, io.b)
    mulAddRecFN.io.roundingMode   := io.roundingMode
    mulAddRecFN.io.detectTininess := io.detectTininess

    io.expected.recOut := recFNFromFN(expWidth, sigWidth, io.expected.out)

    io.actual.out := mulAddRecFN.io.out
    io.actual.exceptionFlags := mulAddRecFN.io.exceptionFlags

    io.check := true.B
    io.pass :=
        equivRecFN(expWidth, sigWidth, io.actual.out, io.expected.recOut) &&
        (io.actual.exceptionFlags === io.expected.exceptionFlags)
}

class ValExec_MulAddRecFN_mul(expWidth: Int, sigWidth: Int) extends Module
{
    val io = IO(new Bundle {
        val a = Input(Bits((expWidth + sigWidth).W))
        val b = Input(Bits((expWidth + sigWidth).W))
        val roundingMode   = Input(UInt(3.W))
        val detectTininess = Input(UInt(1.W))

        val expected = new Bundle {
            val out = Input(Bits((expWidth + sigWidth).W))
            val exceptionFlags = Input(Bits(5.W))
            val recOut = Output(Bits((expWidth + sigWidth + 1).W))
        }

        val actual = new Bundle {
            val out = Output(Bits((expWidth + sigWidth + 1).W))
            val exceptionFlags = Output(Bits(5.W))
        }

        val check = Output(Bool())
        val pass = Output(Bool())
    })
    val mulAddRecFN = Module(new MulAddRecFN(expWidth, sigWidth))
    mulAddRecFN.io.op := 0.U
    mulAddRecFN.io.a := recFNFromFN(expWidth, sigWidth, io.a)
    mulAddRecFN.io.b := recFNFromFN(expWidth, sigWidth, io.b)
    mulAddRecFN.io.c :=
        ((io.a ^ io.b) & (BigInt(1)<<(expWidth + sigWidth - 1)).U)<<1
    mulAddRecFN.io.roundingMode   := io.roundingMode
    mulAddRecFN.io.detectTininess := io.detectTininess

    io.expected.recOut := recFNFromFN(expWidth, sigWidth, io.expected.out)

    io.actual.out := mulAddRecFN.io.out
    io.actual.exceptionFlags := mulAddRecFN.io.exceptionFlags

    io.check := true.B
    io.pass :=
        equivRecFN(expWidth, sigWidth, io.actual.out, io.expected.recOut) &&
        (io.actual.exceptionFlags === io.expected.exceptionFlags)
}

class MulAddRecFNSpec extends FMATester {
    def test(f: Int, fn: String): Seq[String] = {
        test(
            s"MulAddRecF${f}${fn match {
                case "add" => "_add"
                case "mul" => "_mul"
                case "mulAdd" => ""
            }}",
            () => fn match {
                case "add" => new ValExec_MulAddRecFN_add(exp(f), sig(f))
                case "mul" => new ValExec_MulAddRecFN_mul(exp(f), sig(f))
                case "mulAdd" => new ValExec_MulAddRecFN(exp(f), sig(f))
            },
            Seq(s"f${f}_${fn}")
        )
    }
    "MulAddRecF16" should "pass" in {
        check(test(16, "mulAdd"))
    }
    "MulAddRecF32" should "pass" in {
        check(test(32, "mulAdd"))
    }
    "MulAddRecF64" should "pass" in {
        check(test(64, "mulAdd"))
    }
    "MulAddRecF16_add" should "pass" in {
        check(test(16, "add"))
    }
    "MulAddRecF32_add" should "pass" in {
        check(test(32, "add"))
    }
    "MulAddRecF64_add" should "pass" in {
        check(test(64, "add"))
    }
    "MulAddRecF16_mul" should "pass" in {
        check(test(16, "mul"))
    }
    "MulAddRecF32_mul" should "pass" in {
        check(test(32, "mul"))
    }
    "MulAddRecF64_mul" should "pass" in {
        check(test(64, "mul"))
    }
    "generate verilog" should "pass" in {
        (new chisel3.stage.ChiselStage).emitVerilog(new SystolicArray(16,16,8,24))
    }
 
}
