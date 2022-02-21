#pragma rtGlobals=1		// Use modern global access method.



///  ver 3.0  ver2.xから、RhomboBZを修正。以前のものはまちがい
///  ver 3.1  RhomboBZ_kzkx_GLUT_hexを修正。ver3.0ではrcの値が２倍になっていた。
///           RhomboBZ_kzkx_GLUT, ...._hexを修正。横のoffsetをかけた時のkzがずれていた。

///  ver 3.4  monoclinic追加; MonoClinicBZ_kzkx_GYZC,MonoClinicBZ_kzkx_GZXD(
///  ver 3.5  monoclinic in ver 3.4 was wrong. Correct vrsion for BZ of monoclinic is implemeted 

///  ver 3.6  hexagonalBZ_kzkx_GK and hexagonalBZ_kzkx_GM have been delted, and modern function 
///				for GKM kzkx and GMG kzkx have been made (HexBZ_kzkx_GKG and HexBZ_kzkx_GMG)



Function UpdataKzArc2(hn,flag_kzcorrection,photon_ang)
	variable hn
	variable flag_kzcorrection
	variable photon_ang //// baem angle
								/////  BL2  baem ange from sample normal
								/////  ADRESS  value of theta

	Variable/G workfunction
	Variable/G hv
	Variable/G InnerPotential
	
	hv = hn

	make/N=300/D/O  kzarc
	variable acceptance = 14
	variable kxrange = 0.512*sqrt(hv+InnerPotential-workfunction)*sin(acceptance/2*pi/180)
	SetScale/I x (-kxrange),(kxrange),"", kzarc
	variable photon_x, photon_z
	
	 //photon_z =  2*pi/(1240/hn*10) *sin((20+photon_ang)*pi/180)  //ADDRES
	 photon_z = 2*pi/(1240/hn*10) *sin((30+photon_ang)*pi/180)   //BL2
	 //photon_x =  2*pi/(1240/hn*10) *cos((20+photon_ang)*pi/180)  //ADDRES
	 photon_x = 2*pi/(1240/hn*10) *cos((30+photon_ang)*pi/180) //BL2

	
	if (flag_kzcorrection==0)
	kzarc=sqrt(0.512*0.512*(hv+InnerPotential-workfunction)-x*x)
	print "InnerPotential =",InnerPotential, "WorkFunction =", workfunction
	
	
	elseif (flag_kzcorrection==1)
		photon_x=0
		kzarc=sqrt(0.512*0.512*(hv+InnerPotential-workfunction)-(x+photon_x)^2) + photon_z
		print "InnerPotential =",InnerPotential, "WorkFunction =", workfunction
		print "photon momentum corrected"
		print photon_x, photon_z
	endif

	
End 

Function PhotonCorrectionKzArc2(hn)
	variable hn
	wave kzarc
	
	variable pcz = 2*pi/(1240/hn*10) * 0.5
	kzarc += pcz
end
	

Function UpdataKzArcTheta(hn, accept, normal)
	variable hn
	variable accept
	variable normal
	Variable/G workfunction
	Variable/G hv
	Variable/G InnerPotential
	
	hv = hn

	variable thetapnt
	thetapnt = accept * 10 + 1
	make/N=(thetapnt)/D/O thetax, kthetax, kzarct
	
	thetax = 0.1 * p - normal
	kthetax = 0.512 * sqrt(hn - workfunction) * sin(thetax/180*pi)
	kzarct=sqrt(0.512*0.512*(hv+InnerPotential)-kthetax*kthetax)
	print "InnerPotential =",InnerPotential, ", WorkFunction =",workfunction

	
End 

Function UpdataThetaArc()
	Variable/G workfunction
	Variable/G hv
	Variable/G InnerPotential

	make/N=141/D/O  ThetaArc, ThetaKx
	SetScale/P x -7,0.1,"", ThetaArc, ThetaKx
	
	ThetaKx = 0.512*sqrt(hv-workfunction)*sin(x*pi/180)
	ThetaArc=sqrt(0.512*0.512*(hv-workfunction+InnerPotential)-ThetaKx*ThetaKx)
	
End Macro

Function ThetaArcSet(wn,hv,step,appfl)
vAriable wn
variable hv
variable step 
variable appfl

	Variable/G InnerPotential
	Variable/G workfunction

	variable ii =0 
	String thetawn, thetawx
	
	Do
		thetawn = "arckz" + num2str(ii)
		thetawx = "arckx" + num2str(ii)
		make/N=141/D/O  ty, tx
		SetScale/P x -5,0.1,"", ty, tx
		tx = 0.512*sqrt(hv-workfunction)*sin(x*pi/180)
		ty=sqrt(0.512*0.512*(hv+(ii*step)-workfunction+InnerPotential)-tx*tx)
		duplicate/o tx $thetawx
		duplicate/o ty $thetawn
			if (appfl==1)
				AppendtoGraph  $thetawn vs $thetawx
			endif
		ii = ii + 1
	while (ii<wn)	
	
end



Function DrawSetKzArcs()

	Variable/G workfunction
	Variable/G hv
	Variable/G InnerPotential
	
	wave kzarc
	SetScale/P x -0.2,0.01,"", kzarc

	string WN
	variable hvw
	variable i=3
	
	Do
		hvw = i*10
		wn = "kzarc" + num2str(hvw)
		kzarc = sqrt(0.512*0.512*(hvw-workfunction+InnerPotential)-x*x)	
		duplicate/o kzarc $wn
		i = i+1
	while(i<12)
	
	
End


Function fccBZ_kzkx_XWX(aa,yn,yoff,xn,xoff)
	variable aa
	variable yn,yoff,xn,xoff
	
	make/N=1/D/O fcczBy
	make/N=1/D/O fcczBx
	
	
	variable unitcellpnts = 9
	make/N=(unitcellpnts)/D/O uzby
	make/N=(unitcellpnts)/D/O uzbx
	fcczBy=Nan
	fcczBx=Nan
	
	duplicate/o uzby BZcordy
	duplicate/o uzbx BZcordx
	 
	BZcordy = {2,1,-1,-2,-2,-1,1,2,2}
	BZcordx = {1,2,2,1,-1,-2,-2,-1,1}

	variable i=0
	do
		uzby[i] = (pi/aa) * BZcordy[i]
		uzbx[i] = (pi/aa) * BZcordx[i]
		i=i+1
	while (i<(unitcellpnts))

		
	variable ynth, xnth
	variable insn
	
	xnth=0
	do
	
	ynth=0
	do
		insn = (ynth + xnth * yn) * (unitcellpnts + 1)
		InsertPoints (insn),(unitcellpnts+1), fcczBx,fcczBy
		fcczBx[insn] = NaN
		fcczBy[insn] = NaN

		i=0
		do
			fcczBy[insn+i+1] = uzby[i]+ynth*(pi/aa)*4
			fcczBx[insn+i+1] = uzbx[i]+xnth*(pi/aa)*4
			i=i+1
		while(i<unitcellpnts)
		
		ynth += 1
		
	while(ynth < yn)
	
		xnth += 1
	
	while(xnth < xn)
	
	
	
	fcczBy = fcczBy + yoff *(pi/aa)*4
	fcczBx = fcczBx + xoff *(pi/aa)*4

		
End



Function fccBZ_kzkx_GKX(aa,yn,yoff,xn,xoff)
	variable aa
	variable yn,yoff,xn,xoff
	
	make/N=1/D/O fcczBy
	make/N=1/D/O fcczBx
	
	
	variable unitcellpnts = 7
	make/N=(unitcellpnts)/D/O uzby
	make/N=(unitcellpnts)/D/O uzbx
	fcczBy=Nan
	fcczBx=Nan
	
	duplicate/o uzby BZcordy
	duplicate/o uzbx BZcordx
	 
	BZcordy = {2,0,-2, -2,0,2,2}
	BZcordx = {1/sqrt(2),3/sqrt(2),1/sqrt(2),-1/sqrt(2) ,-3/sqrt(2),-1/sqrt(2),1/sqrt(2)}

	variable i=0
	do
		uzby[i] = (pi/aa) * BZcordy[i]
		uzbx[i] = (pi/aa) * BZcordx[i]
		i=i+1
	while (i<(unitcellpnts))

		
	variable ynth, xnth
	variable insn
	
	xnth=0
	do
	
	ynth=0
	do
		insn = (ynth + xnth * yn) * (unitcellpnts + 1)
		InsertPoints (insn),(unitcellpnts+1), fcczBx,fcczBy
		fcczBx[insn] = NaN
		fcczBy[insn] = NaN

		i=0
		do
			fcczBy[insn+i+1] = uzby[i]+ynth*(pi/aa)*4 + mod(xnth,2)*(pi/aa)*2
			fcczBx[insn+i+1] = uzbx[i]+xnth*(pi/aa)*sqrt(2)*2
			i=i+1
		while(i<unitcellpnts)
		
		ynth += 1
		
	while(ynth < yn)
	
		xnth += 1
	
	while(xnth < xn)
	

	fcczBy = fcczBy + yoff *(pi/aa)*4
	fcczBx = fcczBx + xoff *(pi/aa)*sqrt(2)*2

		
End



Function fccBZ_kzkx_GLXL(aa,yn,yoff,xn,xoff)
	variable aa
	variable yn,yoff,xn,xoff
	
	make/N=1/D/O fcczBy
	make/N=1/D/O fcczBx
	
	
	variable unitcellpnts = 7
	make/N=(unitcellpnts)/D/O uzby
	make/N=(unitcellpnts)/D/O uzbx
	fcczBy=Nan
	fcczBx=Nan
	
	duplicate/o uzby BZcordy, BZcordyB
	duplicate/o uzbx BZcordx, BZcordxB
	 
	BZcordyB = {2,0,-2, -2,0,2,2}
	BZcordxB = {1/sqrt(2),3/sqrt(2),1/sqrt(2),-1/sqrt(2) ,-3/sqrt(2),-1/sqrt(2),1/sqrt(2)}

	BZcordx = 1/sqrt(3) * BZcordxB - sqrt(2)/sqrt(3)*BZcordyB
	BZcordy = sqrt(2)/sqrt(3) * BZcordxB + 1/sqrt(3)*BZcordyB
	
	variable i=0
	do
		uzby[i] = (pi/aa) * BZcordy[i]
		uzbx[i] = (pi/aa) * BZcordx[i]
		i=i+1
	while (i<(unitcellpnts))

		
	variable ynth, xnth
	variable insn
	
	xnth=0
	do
	
	ynth=0
	do
		insn = (ynth + xnth * yn) * (unitcellpnts + 1)
		InsertPoints (insn),(unitcellpnts+1), fcczBx,fcczBy
		fcczBx[insn] = NaN
		fcczBy[insn] = NaN

		i=0
		do
			fcczBy[insn+i+1] = uzby[i]+ynth*(pi/aa)*2*sqrt(3) + (mod((xnth+1),3)-1)*(pi/aa)*sqrt(3)*2/3
			fcczBx[insn+i+1] = uzbx[i]+xnth*(pi/aa)*4*sqrt(2/3)
			i=i+1
		while(i<unitcellpnts)
		
		ynth += 1
		
	while(ynth < yn)
	
		xnth += 1
	
	while(xnth < xn)
	

	fcczBy = fcczBy + yoff *(pi/aa)*4 + (mod((xoff),3))*(pi/aa)*sqrt(3)*2/3
	fcczBx = fcczBx + xoff *(pi/aa)*sqrt(2)*2

		
End



Function TetraBZ_kzkx(aa,cc,yn,yoff,xn,xoff)
	variable cc,aa
	variable yn,yoff,xn,xoff
	
	make/N=1/D/O tetraZBy
	make/N=1/D/O tetraZBx
	
	
	variable unitcellpnts = 5
	make/N=(unitcellpnts)/D/O uzby
	make/N=(unitcellpnts)/D/O uzbx
	tetraZBy=Nan
	tetraZBx=Nan
	
	duplicate/o uzby BZcordy
	duplicate/o uzbx BZcordx
	 
	BZcordy = {1,1,-1,-1,1}
	BZcordx = {-1,1,1,-1,-1}

	variable i=0
	do
		uzby[i] = (pi/cc) * BZcordy[i]
		uzbx[i] = (pi/aa) * BZcordx[i]
		i=i+1
	while (i<(unitcellpnts))

		
	variable ynth, xnth
	variable insn
	
	xnth=0
	do
	
	ynth=0
	do
		insn = (ynth + xnth * yn) * (unitcellpnts + 1)
		InsertPoints (insn),(unitcellpnts+1), tetraZBx,tetraZBy
		tetraZBx[insn] = NaN
		tetraZBy[insn] = NaN

		i=0
		do
			tetrazBy[insn+i+1] = uzby[i]+ynth*(pi/cc)*2
			tetrazBx[insn+i+1] = uzbx[i]+xnth*(pi/aa)*2
			i=i+1
		while(i<unitcellpnts)
		
		ynth += 1
		
	while(ynth < yn)
	
		xnth += 1
	
	while(xnth < xn)
	
	
	
	tetrazBy = tetrazBy + yoff *(pi/cc)*2
	tetrazBx = tetrazBx + xoff *(pi/aa)*2

		
End

Function HexBZ_kzkx_GMLA(aa,cc,yn,yoff,xn,xoff)
	variable cc,aa
	variable yn,yoff,xn,xoff
	
	make/N=1/D/O hexZBy
	make/N=1/D/O hexZBx
	
	
	variable unitcellpnts = 5
	make/N=(unitcellpnts)/D/O uzby
	make/N=(unitcellpnts)/D/O uzbx
	hexZBy=Nan
	hexZBx=Nan
	
	duplicate/o uzby BZcordy
	duplicate/o uzbx BZcordx
	 
	BZcordy = {-1,-1,1,1,-1}
	BZcordx = {2/sqrt(3),-2/sqrt(3),-2/sqrt(3),2/sqrt(3),2/sqrt(3)}

	variable i=0
	do
		uzby[i] = (pi/cc) * BZcordy[i]
		uzbx[i] = (pi/aa) * BZcordx[i]
		i=i+1
	while (i<(unitcellpnts))

		
	variable ynth, xnth
	variable insn
	
	xnth=0
	do
	
	ynth=0
	do
		insn = (ynth + xnth * yn) * (unitcellpnts + 1)
		InsertPoints (insn),(unitcellpnts+1), hexZBx,hexZBy
		hexZBx[insn] = NaN
		hexZBy[insn] = NaN

		i=0
		do
			hexZBy[insn+i+1] = uzby[i]+ynth*(pi/cc)*2
			hexZBx[insn+i+1] = uzbx[i]+xnth*(pi/aa)*2*2/sqrt(3)
			i=i+1
		while(i<unitcellpnts)
		
		ynth += 1
		
	while(ynth < yn)
	
		xnth += 1
	
	while(xnth < xn)
	
	
	
	hexZBy = hexZBy + yoff *(pi/cc)*2
	hexZBx = hexZBx + xoff *(pi/aa)*2*2/sqrt(3)

		
End

Function HexBZ_kzkx_GKHA(aa,cc,yn,yoff,xn,xoff)
	variable cc,aa
	variable yn,yoff,xn,xoff
	
	make/N=1/D/O hexZBy
	make/N=1/D/O hexZBx
	
	
	variable unitcellpnts = 8
	make/N=(unitcellpnts)/D/O uzby
	make/N=(unitcellpnts)/D/O uzbx
	hexZBy=Nan
	hexZBx=Nan
	
	duplicate/o uzby BZcordy
	duplicate/o uzbx BZcordx
	 
	BZcordy = {-1,-1,1,1,-1,-1,1,1}
	BZcordx = {4/3,-4/3,-4/3,4/3,4/3,8/3,8/3,4/3}

	variable i=0
	do
		uzby[i] = (pi/cc) * BZcordy[i]
		uzbx[i] = (pi/aa) * BZcordx[i]
		i=i+1
	while (i<(unitcellpnts))

		
	variable ynth, xnth
	variable insn
	
	xnth=0
	do
	
	ynth=0
	do
		insn = (ynth + xnth * yn) * (unitcellpnts + 1)
		InsertPoints (insn),(unitcellpnts+1), hexZBx,hexZBy
		hexZBx[insn] = NaN
		hexZBy[insn] = NaN

		i=0
		do
			hexZBy[insn+i+1] = uzby[i]+ynth*(pi/cc)*2
			hexZBx[insn+i+1] = uzbx[i]+xnth*(pi/aa)*2*2
			i=i+1
		while(i<unitcellpnts)
		
		ynth += 1
		
	while(ynth < yn)
	
		xnth += 1
	
	while(xnth < xn)
	
	
	
	hexZBy = hexZBy + yoff *(pi/cc)*2
	hexZBx = hexZBx + xoff *(pi/aa)*2*2

		
End


Function RhomboBZ_kzkx_GLUT(aa,alpha,yn,yoff,xn,xoff)
	variable aa, alpha
	variable yn,yoff,xn,xoff
	
	make/N=1/D/O RhZBy, RhZBx
	
	
	variable unitcellpnts = 7
	make/N=(unitcellpnts)/D/O uzby
	make/N=(unitcellpnts)/D/O uzbx
	RhZBy=Nan
	RhZBx=Nan
	
	duplicate/o uzby BZcordy
	duplicate/o uzbx BZcordx
	
	variable etha, rs, rc
	
	etha = (1+4*cos(alpha*pi/180))/(2+4*cos(alpha*pi/180))
	rs = sqrt(3/(2-2*cos(alpha*pi/180))) //  1/sin(theta)のこと
	rc = sqrt(3/(1+2*cos(alpha*pi/180)))/2 //  1/2cos(theta)のこと
	
	print  etha, rs, rc


	BZcordx = {(etha-0.5)*rs, (7/6-etha)*rs, (etha-0.5)*rs, -(etha-0.5)*rs, (etha-7/6)*rs, -(etha-0.5)*rs, (etha-0.5)*rs}
	BZcordy = {rc, -rc/3, -rc, -rc, rc/3, rc, rc}
	
	
	variable i=0
	do
		uzbx[i] = 2*pi/aa * BZcordx[i]
		uzby[i] = 2*pi/aa * BZcordy[i]
		i=i+1
	while (i<(unitcellpnts))



	variable cc		
	variable ynth, xnth
	variable insn
	variable GCy = (2*pi/aa) *rc*2
	variable GCx = (2*pi/aa) *(2/3)*rs

	xnth=0
	do
	
	ynth=0
	do
		insn = (ynth + xnth * yn) * (unitcellpnts + 1)
		InsertPoints (insn),(unitcellpnts+1), RhZBx,RhZBy
		RhZBx[insn] = NaN
		RhZBy[insn] = NaN

		i=0
		do
			RhZBy[insn+i+1] = uzby[i]+ynth*GCy    +(mod((xnth+1),3)-1)*(GCy/3)   //-4 *pi/unitc
			RhZBx[insn+i+1] = uzbx[i]+xnth*GCx
			i=i+1
		while(i<unitcellpnts)
		
		ynth += 1
		
	while(ynth < yn)
	
		xnth += 1
	
	while(xnth < xn)
	

	RhZBy = RhZBy + yoff *GCy + (mod((xoff),3))*GCy/3
	RhZBx = RhZBx + xoff *GCx

		
End

Function RhomboBZ_kzkx_GLUT_hex(ah,ch,yn,yoff,xn,xoff)
	variable ah,ch
	variable yn,yoff,xn,xoff
		
	variable aa,alpha

	aa = sqrt(ah^2*3+ ch^2)/3
	alpha = acos(1-ah^2/2/aa^2)/pi*180
	
	print aa, alpha
	
	make/N=1/D/O RhZBy, RhZBx
	
	
	variable unitcellpnts = 7
	make/N=(unitcellpnts)/D/O uzby
	make/N=(unitcellpnts)/D/O uzbx
	RhZBy=Nan
	RhZBx=Nan
	
	duplicate/o uzby BZcordy
	duplicate/o uzbx BZcordx
	
	variable etha, rs, rc
	
	etha = (1+4*cos(alpha*pi/180))/(2+4*cos(alpha*pi/180))
	rs = sqrt(3/(2-2*cos(alpha*pi/180))) //  1/sin(theta)のこと
	rc = sqrt(3/(1+2*cos(alpha*pi/180)))/2 //  1/2cos(theta)のこと
	
	print  etha, rs, rc

	BZcordx = {(etha-0.5)*rs, (7/6-etha)*rs, (etha-0.5)*rs, -(etha-0.5)*rs, (etha-7/6)*rs, -(etha-0.5)*rs, (etha-0.5)*rs}
	BZcordy = {rc, -rc/3, -rc, -rc, rc/3, rc, rc}
	
	
	variable i=0
	do
		uzbx[i] = 2*pi/aa * BZcordx[i]
		uzby[i] = 2*pi/aa * BZcordy[i]
		i=i+1
	while (i<(unitcellpnts))



	variable cc		
	variable ynth, xnth
	variable insn
	variable GCy = (2*pi/aa) *rc*2
	variable GCx = (2*pi/aa) *(2/3)*rs

	xnth=0
	do
	
	ynth=0
	do
		insn = (ynth + xnth * yn) * (unitcellpnts + 1)
		InsertPoints (insn),(unitcellpnts+1), RhZBx,RhZBy
		RhZBx[insn] = NaN
		RhZBy[insn] = NaN

		i=0
		do
			RhZBy[insn+i+1] = uzby[i]+ynth*GCy    +(mod((xnth+1),3)-1)*(GCy/3)   //-4 *pi/unitc
			RhZBx[insn+i+1] = uzbx[i]+xnth*GCx
			i=i+1
		while(i<unitcellpnts)
		
		ynth += 1
		
	while(ynth < yn)
	
		xnth += 1
	
	while(xnth < xn)
	

	RhZBy = RhZBy + yoff *GCy + (mod((xoff),3))*GCy/3 
	RhZBx = RhZBx + xoff *GCx

		
End


Function RhomboBZ_kxky (aa,alpha,yn,yoff,xn,xoff)
	variable aa, alpha
	variable yn,yoff,xn,xoff
	
	make/N=1/D/O RhZBy, RhZBx
	
	
	variable unitcellpnts = 20
	make/N=(unitcellpnts)/D/O uzby
	make/N=(unitcellpnts)/D/O uzbx
	RhZBy=Nan
	RhZBx=Nan
	
	duplicate/o uzby BZcordy
	duplicate/o uzbx BZcordx
	
	variable etha, nu, rs, rc
	
	etha = (1+4*cos(alpha*pi/180))/(2+4*cos(alpha*pi/180))
	nu = 3/4 - etha/2
	rs = sqrt(3/(2-2*cos(alpha*pi/180))) //  1/sin(theta)のこと
	rc = sqrt(3/(1+2*cos(alpha*pi/180)))/2 //  1/2cos(theta)のこと
	
	
	make/N=3/D/O R1, R2, R3  // Romboの逆格子ベクトルを定義　単位は 2pi/a
	R1[0] = sqrt(3)/2*rs
	R1[1] = -1/2 *rs
	R1[2] = rc
	R2[0] = 0
	R2[1] = rs
	R2[2] = rc
	R3[0] = -sqrt(3)/2*rs
	R3[1] = -1/2 *rs
	R3[2] = rc
	
	R1 = R1 *2/3
	R2 = R2 *2/3
	R3 = R3 *2/3

	
	make/N=3/D/O P0, P1, P2, B0, B1
	variable i=0
	Do
		P0[i] = etha * R2[i] + nu * R3[i] + nu * R1[i]
		P1[i] = (1-nu) * R2[i] + (1-nu) * R3[i] + (1-etha) * R1[i]
		P2[i] = nu * R2[i] + nu * R3[i] + (etha-1) * R1[i]
		B0[i] = etha * R2[i] + 0.5 * R3[i] + (1-etha) * R1[i]
		B1[i] = 0.5 * R2[i] + (1-etha) * R3[i] + (etha-1) * R1[i]
		i = i + 1
	while (i<3)
	
//	P0 = P0 * 2*pi/aa
//	P1 = P1 * 2*pi/aa
//	P2 = P2 * 2*pi/aa
//	B0 = B0 * 2*pi/aa
//	B1 = B1 * 2*pi/aa



	BZcordx = {P0[0], P1[0], P2[0], B0[0], B1[0]}
	BZcordy = {P0[1], P1[1], P2[1], B0[1], B1[1]}
	
	
	do
		uzbx[i] = 2*pi/aa * BZcordx[i]
		uzby[i] = 2*pi/aa * BZcordy[i]
		i=i+1
	while (i<(unitcellpnts))



	variable cc		
	variable ynth, xnth
	variable insn
	variable GCy = (2*pi/aa) *rc*2
	variable GCx = (2*pi/aa) *(2/3)*rs

	xnth=0
	do
	
	ynth=0
	do
		insn = (ynth + xnth * yn) * (unitcellpnts + 1)
		InsertPoints (insn),(unitcellpnts+1), RhZBx,RhZBy
		RhZBx[insn] = NaN
		RhZBy[insn] = NaN

		i=0
		do
			RhZBy[insn+i+1] = uzby[i]+ynth*GCy    +(mod((xnth+1),3)-1)*(GCy/3)   //-4 *pi/unitc
			RhZBx[insn+i+1] = uzbx[i]+xnth*GCx
			i=i+1
		while(i<unitcellpnts)
		
		ynth += 1
		
	while(ynth < yn)
	
		xnth += 1
	
	while(xnth < xn)
	

	RhZBy = RhZBy + yoff *GCy + (mod((xoff),3))*GCx/3
	RhZBx = RhZBx + xoff *GCx

		
End



Function MonoClinicBZ_kzkx_GZXD(aa,cc,betha,yn,yoff,xn,xoff)
	variable aa,cc,betha
	variable yn,yoff,xn,xoff
	
	make/N=1/D/O MCZBDy, MCZBDx
	
	
	variable unitcellpnts = 7
	make/N=(unitcellpnts)/D/O uzby
	make/N=(unitcellpnts)/D/O uzbx
	MCZBDy=Nan
	MCZBDx=Nan
	
	duplicate/o uzby BZcordy
	duplicate/o uzbx BZcordx
	
	variable px,rc,rs, asx, asy, csy
	rc = cos(betha/180*pi)
	rs = sin(betha/180*pi)
	asx = 2*pi/aa
	asy = -2*pi/aa*rc/rs
	csy = 2*pi/cc/rs
	
	
	make/N=2/D/O ax,ay
	ax={0,asx}
	ay={0,asy}

	px = -pi/cc*abs(rc)/(rs^2) + pi/aa/(rs^2)

	if (betha>=90)
		uzbx[0]=px
		uzby[0]=csy/2
		uzbx[1]=-px
		uzby[1]=uzby[0]
		uzbx[2]=uzbx[0]-asx
		uzby[2]=uzby[0]-asy
		uzbx[3]=-px
		uzby[3]=-csy/2
		uzbx[4]=px
		uzby[4]=-csy/2
		uzbx[5]=-uzbx[2]
		uzby[5]=-uzby[2]
		uzbx[6]=uzbx[0]
		uzby[6]=uzby[0]
	
	elseif (betha<90)
		uzbx[0]=px
		uzby[0]=csy/2
		uzbx[1]=-px
		uzby[1]=uzby[0]
		uzbx[2]=uzbx[0]-asx
		uzby[2]=-uzby[0]-asy
		uzbx[3]=-px
		uzby[3]=-csy/2
		uzbx[4]=px
		uzby[4]=-csy/2
		uzbx[5]=-uzbx[2]
		uzby[5]=-uzby[2]
		uzbx[6]=uzbx[0]
		uzby[6]=uzby[0]
	endif
	
	variable ynth, xnth
	variable insn,i


	xnth=0
	do
	
	ynth=0
	do
		insn = (ynth + xnth * yn) * (unitcellpnts + 1)
		InsertPoints (insn),(unitcellpnts+1), MCZBDy,MCZBDx
		MCZBDx[insn] = NaN
		MCZBDy[insn] = NaN

		i=0
		do
			MCZBDy[insn+i+1] = uzby[i]+ynth*csy   +asy*xnth  - floor(xnth/2)*csy  //-4 *pi/unitc
			MCZBDx[insn+i+1] = uzbx[i]+xnth*asx
			i=i+1
		while(i<unitcellpnts)
		
		ynth += 1
		
	while(ynth < yn)
	
		xnth += 1
	
	while(xnth < xn)
	

	MCZBDy = MCZBDy + yoff *csy+ asy*xoff  - floor(xoff/2)*csy
	MCZBDx = MCZBDx + xoff *asx
	
End

Function MonoClinicBZ_kzkx_GYZC(bb,cc,betha,yn,yoff,xn,xoff)
	variable bb,cc,betha
	variable yn,yoff,xn,xoff
	
	make/N=1/D/O MCZBy, MCZBx
	
	
	variable unitcellpnts = 5
	make/N=(unitcellpnts)/D/O uzby
	make/N=(unitcellpnts)/D/O uzbx
	MCZBy=Nan
	MCZBx=Nan
	
	duplicate/o uzby BZcordy
	duplicate/o uzbx BZcordx
	
	variable px,rc,rs,rt,bsx,bsy,csy
	rc = cos((betha-90)/180*pi)
	rs = sin((betha-90)/180*pi)
	rt = tan((betha-90)/180*pi)
	bsx = 2*pi/bb
	bsy = 0
	csy = 2*pi/cc/rc
	
	make/N=2/D/O bx,by
	bx={0,bsx}
	by={0,bsy}

	uzbx[0]=bsx/2
	uzby[0]=csy/2
	uzbx[1]=-bsx/2
	uzby[1]=csy/2
	uzbx[2]=-bsx/2
	uzby[2]=-csy/2
	uzbx[3]=bsx/2
	uzby[3]=-csy/2
	uzbx[4]=uzbx[0]
	uzby[4]=uzby[0]

	
	
	variable ynth, xnth
	variable insn,i


	xnth=0
	do
	
	ynth=0
	do
		insn = (ynth + xnth * yn) * (unitcellpnts + 1)
		InsertPoints (insn),(unitcellpnts+1), MCZBy,MCZBx
		MCZBx[insn] = NaN
		MCZBy[insn] = NaN

		i=0
		do
			MCZBy[insn+i+1] = uzby[i]+ynth*csy 
			MCZBx[insn+i+1] = uzbx[i]+xnth*bsx
			i=i+1
		while(i<unitcellpnts)
		
		ynth += 1
		
	while(ynth < yn)
	
		xnth += 1
	
	while(xnth < xn)
	

	MCZBy = MCZBy + yoff *csy
	MCZBx = MCZBx + xoff *bsx
	
End



Function HexBZ_kzkx_GKG(aa,yn,yoff,xn,xoff)
	variable aa
	variable yn,yoff,xn,xoff
	
	make/N=1/D/O hexZBy
	make/N=1/D/O hexZBx
	
	
	variable unitcellpnts = 7
	make/N=(unitcellpnts)/D/O uzby
	make/N=(unitcellpnts)/D/O uzbx
	hexZBy=Nan
	hexZBx=Nan
	
	duplicate/o uzby BZcordy
	duplicate/o uzbx BZcordx
	 
	BZcordy = {2/3,4/3,2/3,-2/3,-4/3,-2/3,2/3}
	BZcordx = {2/sqrt(3),0,-2/sqrt(3), -2/sqrt(3),0,2/sqrt(3),2/sqrt(3)}
	

	variable i=0
	do
		uzby[i] = (pi/aa) * BZcordy[i]
		uzbx[i] = (pi/aa) * BZcordx[i]
		i=i+1
	while (i<(unitcellpnts))


	variable ynth, xnth
	variable insn
	
	xnth=0
	do
	
	ynth=0
	do
		insn = (ynth + xnth * yn) * (unitcellpnts + 1)
		InsertPoints (insn),(unitcellpnts+1), hexZBy,hexZBx
		hexZBx[insn] = NaN
		hexZBy[insn] = NaN

		i=0
		do
			hexZBy[insn+i+1] = uzby[i]+ynth*(pi/aa)*2
			hexZBx[insn+i+1] = uzbx[i]+xnth*(pi/aa)*4/sqrt(3)+mod(ynth,2)*(pi/aa)*2/sqrt(3)
			i=i+1
		while(i<unitcellpnts)
		
		ynth += 1
		
	while(ynth < yn)
	
		xnth += 1
	
	while(xnth < xn)
	

	hexZBy = hexZBy + yoff *(pi/aa)*2
	hexZBx = hexZBx + xoff *(pi/aa)*4/sqrt(3)+mod(yoff,2)*(pi/aa)*2/sqrt(3)

		
End



Function HexBZ_kzkx_GMG(aa,yn,yoff,xn,xoff)
	variable aa
	variable yn,yoff,xn,xoff
	
	make/N=1/D/O hexZBy
	make/N=1/D/O hexZBx
	
	
	variable unitcellpnts = 7
	make/N=(unitcellpnts)/D/O uzby
	make/N=(unitcellpnts)/D/O uzbx
	hexZBy=Nan
	hexZBx=Nan
	
	duplicate/o uzby BZcordy
	duplicate/o uzbx BZcordx
	 
	BZcordy = {0,2/sqrt(3),2/sqrt(3), 0,-2/sqrt(3),-2/sqrt(3),0}
	BZcordx = {4/3,2/3,-2/3,-4/3,-2/3,2/3,4/3}
	

	variable i=0
	do
		uzby[i] = (pi/aa) * BZcordy[i]
		uzbx[i] = (pi/aa) * BZcordx[i]
		i=i+1
	while (i<(unitcellpnts))


	variable ynth, xnth
	variable insn
	
	xnth=0
	do
	
	ynth=0
	do
		insn = (ynth + xnth * yn) * (unitcellpnts + 1)
		InsertPoints (insn),(unitcellpnts+1), hexZBy,hexZBx
		hexZBy[insn] = NaN
		hexZBx[insn] = NaN

		i=0
		do
			hexZBy[insn+i+1] = uzby[i]+ynth*(pi/aa)*4/sqrt(3) + mod(xnth,2)*(pi/aa)*2/sqrt(3)
			hexZBx[insn+i+1] = uzbx[i]+xnth*(pi/aa)*2
			i=i+1
		while(i<unitcellpnts)
		
		ynth += 1
		
	while(ynth < yn)
	
		xnth += 1
	
	while(xnth < xn)
	

	hexZBy = hexZBy + yoff *(pi/aa)*4/sqrt(3)+mod(xoff,2)*(pi/aa)*2/sqrt(3)
	hexZBx = hexZBx + xoff *(pi/aa)*2

		
End