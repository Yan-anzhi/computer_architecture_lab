module top(
    input clk,
    output reg led
);

reg [25:0] cnt;

always @(posedge clk) begin
    if (cnt >= 27_000_000/2 - 1) begin
        cnt <= 0;
        led <= ~led;
    end else begin
        cnt <= cnt + 1;
    end
end

endmodule