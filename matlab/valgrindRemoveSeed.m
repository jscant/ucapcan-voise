Sk = [100 150 205 214 278]
while 1
	VD = load("VD89.mat");
	VD = VD.VD;
	for k=1:5
		VD = removeSeedFromVD(VD, Sk(k));
	end
end
