module MUX5 (
    input        [7:0] ALU_m,
                       data_mem_m,
                       LUT_LSW_m,
                       LUT_MSW_m,
                       ImmOut_m,
    input        [2:0] muxSelect,

    output logic [7:0] dataOut_m
);

always_comb begin
    case(muxSelect)
        0 : dataOut_m = ALU_m;
        1 : dataOut_m = data_mem_m;
        2 : dataOut_m = LUT_LSW_m;
        3 : dataOut_m = LUT_MSW_m;
        4 : dataOut_m = ImmOut_m;
        default : dataOut_m = ALU_m;
    endcase
end

endmodule