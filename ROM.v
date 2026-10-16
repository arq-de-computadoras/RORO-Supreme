//1. declaracion de modulo y I/O
module ROM #(parameter DATA_FILE = "initData.txt") (
	input [3:0]DirL,
	output [31:0]Data
);

//componente interno Memoria

reg [31:0] srom [0:8];


assign Data=srom[DirL];

initial 
begin
	srom[0]=32'd20;
	srom[1]=32'd105;
	srom[2]=32'd100;
	srom[3]=32'd22;
	srom[4]=32'd43;
	srom[5]=32'd400;
	srom[6]=32'd512;
	srom[7]=32'd50;
	srom[8]=32'd10;
end

/*
//necesito qe Data sea: "output reg"
always @*
begin
	Data=srom[DirL];
end
*/
endmodule 