module apb_m
(input [3:0] addrin,
 input [7:0] datain,
 input pclk,
 input newd,
 input wr,
 input presetn,
 input [7:0] prdata,
 input pready,

 output reg [3:0] paddr,
 output reg penable,
 output reg psel,
 output reg pwrite,
 output reg [7:0] pwdata,
 output [7:0] dataout
);

localparam reset   = 0;
localparam idle    = 1;
localparam setup   = 2;
localparam enable  = 3;

reg [1:0] state,nstate;

//-----------------------------------------------------------------
//----------------------------RESET_LOGIC--------------------------
//-----------------------------------------------------------------
//
//
always@(posedge pclk) begin
    if(presetn) begin 
        state <= nstate;
    end
    else begin
        state <= reset;
    end
end

//-----------------------------------------------------------------
//------------------------ADDRESS_DECODE---------------------------
//-----------------------------------------------------------------
//
//
//
always@(*) begin //check if what is change that we see with state and nstate
    case(state)
        reset : begin
            psel = 'd0;
        end
        idle : begin
            psel = 'd0;
        end
        setup : begin
            psel = 'd1;
        end
        enable : begin
            psel = 'd1;
        end
        default : psel = 'd0;
    endcase
end

//----------------------------------------------------------------
//----------------------------NEXT_STATE_DECODE-------------------
//----------------------------------------------------------------
//
//
//
always@(*) begin
    case(state)
        reset : begin
            if(presetn) begin
                nstate = idle;
            end
            else begin 
                nstate = reset;
            end
        end

        idle : begin
            if(newd) begin
                nstate = setup;
            end
            else begin
                nstate = idle;
            end
        end

        setup : begin
            if(psel) begin
                nstate = enable;
            end
            else begin
                nstate = setup;
            end
        end

        enable : begin // check this logic
            if(newd) begin
                if(pready) begin 
                    nstate = setup;
                end
                else begin
                    nstate = enable;
                end
            end
        end
    endcase
end

//-----------------------------------------------------------------
//------------------------OUTPUT_DECODE_LOGIC----------------------
//-----------------------------------------------------------------
//
//
//
always@(*) begin
    case(state)
        reset : begin
            paddr   = 'd0;
            psel    = 'd0;
            pwrite  = 'd0;
            penable = 'd0;
            pwdata  = 'd0;
        end

        idle : begin
            paddr   = 'd0;
            psel    = 'd0;
            pwrite  = 'd0;
            penable = 'd0;
            pwdata  = 'd0;
        end

        setup : begin
            psel   = 'd1;
            if(~wr) begin //write operation
                pwrite  = wr;
                paddr   = addrin;
                pwdata  = datain;
                penable = 'd0;
            end
            else begin
                pwrite  = ~wr;
                paddr   = addrin;
                penable = 'd0;
            end
        end
        
        enable : begin
            penable  = 'd1;
        end
    endcase
end
   assign dataout = (penable == 'd1 && pready == 'd1 && pwrite == 'd1) ? prdata : 'd0;
endmodule
