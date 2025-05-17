`timescale 1ns/1ps

module tb();

    reg clk = 0;
    reg rst_n;
    wire wr_en;
    reg rd_en;
    wire [7:0] data_in;
    wire [7:0] data_out;
    wire full;
    wire empty;
    wire [3:0] fifo_words;

    reg [0:0] file_data [0:15];

    fifo f(
        .clk(clk),
        .rst_n(rst_n),
        .wr_en(wr_en),
        .rd_en(rd_en),
        .data_in(data_in),
        .data_out(data_out),
        .full(full),
        .empty(empty),
        .fifo_words(fifo_words)
    );

    fsm fsm(
        .clk(clk),
        .rst_n(rst_n),
        .wr_en(wr_en),
        .fifo_data(data_in),
        .fifo_words(fifo_words)
    );

    always #1 clk = ~clk;


    integer i;
    initial begin
        $monitor("rstn=%b, wr_en=%b, rd_en=%b, data_in=%b, data_out=%b, full=%b, empty=%b, fifo_words=%b", 
                    rst_n, wr_en, rd_en, data_in, data_out, full, empty, fifo_words);

        $readmemb("teste.txt", file_data);
        $dumpfile("saida.vcd");
        $dumpvars(0, tb);

        rst_n = 0;
        rd_en = 0;
        #2;
        rst_n = 1;

        for (i = 0; i < 16; i = i + 1) begin
            rd_en = file_data[i][0];
            #2;
        end

        $finish;
    end
endmodule