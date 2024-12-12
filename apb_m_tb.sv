module apb_m_tb;
 reg [3:0] addrin;
 reg [7:0] datain;
 reg pclk;
 reg newd;
 reg wr;
 reg presetn;
 reg [7:0] prdata;
 reg pready;

 wire [3:0] paddr;
 wire penable;
 wire psel;
 wire pwrite;
 wire [7:0] pwdata;
 wire [7:0] dataout;
 //-----------------------------------------------
 //-----------------DUT_CONNECTION----------------
 //-----------------------------------------------
 //
 apb_m dut
 ( 
 .addrin(addrin),
 .datain(datain),
 .pclk(pclk),
 .presetn(presetn),
 .newd(newd),
 .wr(wr),
 .prdata(prdata),
 .pready(pready),
 .paddr(paddr),
 .penable(penable),
 .psel(psel),
 .pwrite(pwrite),
 .pwdata(pwdata),
 .dataout(dataout)
);

//------------------------------------------------
//---------------------CLOCK----------------------
//------------------------------------------------
//
//

always #10 pclk = ~ pclk;

//------------------------------------------------
//--------------------INITIALIZATION--------------
//------------------------------------------------
//
//

initial begin
    pclk = 'd0;
end

//------------------------------------------------
//---------------------RESET----------------------
//------------------------------------------------
 initial begin
     @(posedge pclk);
     presetn = 'd0;
     $display("------------------------------------------");
     $display("----------RESET ASSERTED------------------");
     repeat(5) @(posedge pclk);
     presetn = 'd1;
     $display("------------------------------------------");
     $display("----------RESET DEASSERTED----------------");
 end

 //-----------------------------------------------
 //------------------WRITE_READ-------------------
 //-----------------------------------------------
 //
 //
 initial begin
     repeat(7) @(posedge pclk);
     $display("------------WRITE_OPERATION_STARTED--------");
     newd = 'd1;
     wr = 'd0;
     addrin = 'd4;
     datain = 'd8;
     $display("-----------SETUP_PHASE_ENDED---------------");
     $display("-----------ACCESS_PHASE_STARTED------------");
     @(posedge pclk);
     pready = 'd1;
     @(posedge pclk);
     $display("-----------ACCESS_PHASE_ENDED--------------");
 end

 initial begin
    repeat(30) @(posedge pclk);
    $finish();
 end
endmodule
