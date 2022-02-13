#pragma rtGlobals=3		// Use modern global access method and strict wave access.

#pragma rtGlobals=3		// Use modern global access method and strict wave access.

Variable/G coef_flag
Variable/G showFD_flag


Function MatrixFitting_edge(MName,temp,ireso)
Wave MName
//Wave coefW
Variable temp
Variable ireso

	PauseUpdate; Silent 1
	
	Variable startE, EndE	
	startE = dimoffset(MName,0) + pcsr(A) *  dimdelta(MName,0)
	EndE = dimoffset(MName,0) + pcsr(B) *  dimdelta(MName,0)
	
	if (startE >= EndE)
		DoAlert 0, "CursolA has to be located at lower energy than CursolB!!"
		return -1
	endif 	

	///////////// intial guess ///////////////
	Variable resolution
	Variable EF
	Variable hight, slope, offseth
	Variable xdelta, xsize, xstart
	xsize = dimsize(MName,0)
	xdelta = dimdelta(MName,0)
	xstart = dimoffset(MName,0)

	Make/N=(xsize)/D/O triwave
	SetScale/P x xstart,xdelta,"", triwave
	Make/N=6/O  coef_matfit
	
	triwave[] = MName[p][0]
	WaveFitting_edge_ini(triwave,  coef_matfit, temp, ireso,startE,EndE)
	duplicate/o triwave FDcurve
	
	EF = coef_matfit[2]
	print "Fermi energy", EF
	FDcurve =  (coef_matfit[0] + coef_matfit[1] *x)*      (1/(1+exp((x-coef_matfit[2])/coef_matfit[5]))) + coef_matfit[3] + coef_matfit[4] *x

	
	
	
	//////////////   fitting routine /////////////
	variable ysize, yoffset, ydelta
	ysize = dimsize(MName,1)
	yoffset = dimoffset(MName,1)
	ydelta = dimdelta(MName,1)

	Make/N=(ysize)/D/O Au_EFw
//	Make/N=(ysize)/D/O Au_resow
//	Make/N=(ysize)/D/O Au_hight
//	Make/N=(ysize)/D/O Au_slope
//	Make/N=(ysize)/D/O Au_offseth
//	Make/N=(ysize)/D/O Au_offsetslope

	SetScale/P x yoffset,ydelta,"", Au_EFw
//	SetScale/P x yoffset,ydelta,"", Au_resow

	
	variable ii=0
//	duplicate/o triwave FDcurve

	Do
		triwave[] = MName[p][ii]
		SetScale/P x xstart,xdelta,"", triwave
		duplicate/o triwave FDcurve
		FuncFit/NTHR=0/Q/N EdgeFunction coef_matfit  triwave[pcsr(A),pcsr(B)] /D 
		Au_EFw[ii] = coef_matfit[2]
//		Au_resow[ii] = coefW[5]
//		Au_hight[ii] = coefW[0]
//		Au_slope[ii] = coefW[1]
//		Au_offseth[ii] = coefW[3]
//		Au_offsetslope[ii] = coefW[4]

//		FDcurve =  (coefW[0] + coefW[1] *x)*      (1/(1+exp((x-coefW[2])/coefW[5]))) + coefW[3] + coefW[4] *x
		ii = ii +1
	while (ii < (ysize))	
	
End


Function MatShiftEF(wname,efw)
wave wname
wave efw
	
	duplicate/o efw efp
	efp = efw - sum(efw,-inf,inf)/dimsize(efw,0)
	efp = round(efp/dimdelta(wname,0))
	
	print  sum(efw,-inf,inf)/dimsize(efw,0)
	
	variable ysize, yoffset, ydelta
	ysize = dimsize(wname,1)
	yoffset = dimoffset(wname,1)
	ydelta = dimdelta(wname,1)
	Variable xdelta, xsize, xstart
	xsize = dimsize(wname,0)
	xdelta = dimdelta(wname,0)
	xstart = dimoffset(wname,0)

	Make/N=(xsize)/D/O triwave
	SetScale/P x xstart,xdelta,"", triwave
	
	variable ii=0
	variable shift
	
	Do
		triwave[] = wname[p][ii]
		shift = efp[ii]
		if (shift>0)
			DeletePoints 0,shift,triwave
			InsertPoints inf,shift,triwave		
		else
			InsertPoints 0,(-shift),triwave
			DeletePoints inf,(-shift),triwave
		endif
		wname[][ii] =triwave[p]
		print ii, yoffset+ii*ydelta, efp[ii]
		ii = ii +1
	while(ii<(ysize))

end


Function MatShiftEF_3D(wname,efw)
wave wname
wave efw

	duplicate/o efw efp
	efp = efw - sum(efw,-inf,inf)/dimsize(efw,0)
	efp = round(efp/dimdelta(wname,0))
	
	
	variable ysize, yoffset, ydelta
	ysize = dimsize(wname,1)
	yoffset = dimoffset(wname,1)
	ydelta = dimdelta(wname,1)
	Variable xdelta, xsize, xstart
	xsize = dimsize(wname,0)
	xdelta = dimdelta(wname,0)
	xstart = dimoffset(wname,0)
	variable zsize
	zsize = dimsize(wname,2)

	

	Make/N=(xsize,ysize)/D/O trimat
	SetScale/P x xstart,xdelta,"", trimat
	SetScale/P y yoffset,ydelta,"", trimat
	
	variable ii=0
	variable shift


	Do
		trimat[][] = wname[p][q][ii]
		shift = efp[ii]
		if (shift>0)
			DeletePoints 0,shift,trimat
			InsertPoints inf,shift,trimat		
		else
			InsertPoints 0,(-shift),trimat
			DeletePoints inf,(-shift),trimat
		endif
		wname[][][ii] =trimat[p][q]
		ii = ii +1	
	while(ii<(zsize))


end 


Function EdgeFunction(w,x) : FitFunc
wave w
variable x

	variable yy	
	yy =  (w[0] + w[1] *x)*      (1/(1+exp((x-w[2])/w[5]))) + w[3] + w[4] *x
	
	return yy
End



Function EdgeConvoluted(pw, yw, xw) : FitFunc
wave pw, yw, xw

// pw[0] hight
// pw[1] slope
// pw[2] EF
// pw[3] offseth
// pw[4] resolution

	variable step
	step = abs(xw[1]-xw[0] )
	
//	variable temp_G =300
	
//  Make BroadeningFunction with same step of xw
	variable gauusian_br
	gauusian_br = pw[5]

	Make/N=1001/D/O Gwindow1
	setscale/P x -(500*step), (step), Gwindow1  

	//Gassian broadening function
	Gwindow1 = exp(-x^2/gauusian_br)


	// Normalize ThetaBroadeningFunction
	variable sumexp
	sumexp = sum(Gwindow1, -inf,inf)
	Gwindow1 /= sumexp


	//  To avoid the rounding effect at ends of yw, extention of yw 
	//  at bothe ends is made and stores as ywExt.  Extention length
	// (points) is set to 2*resolution.
	
	variable ywNpnts, Extpnts
	ywNpnts = numpnts(yw)
	Extpnts = round(gauusian_br/step*2)/10
	Extpnts = max(Extpnts,10)
	ywNpnts = ywNpnts + 4*Extpnts
	Make/D/O/N=(ywNpnts)   yWave
	setscale/P x (xw[0]-2*step*Extpnts), step, yWave

	
	 yWave=0
	 Variable/G temp_G

	// Make a simulation of Assymetric Lorenzian
	 yWave= (pw[0] + pw[1] *x)*(1/(1+exp((x-pw[2] )/(temp_G/11600)))) + pw[3] + pw[4]*x
	 
	// Convolve yWave with gaussy
	convolve /A Gwindow1, yWave

	
	 //  extenstion area is removed to srtore the resulting function to yw
	yw = yWave(xw[p])
	
end



Function Audivision(MName, bglevel)
Wave MName
Variable bglevel

	duplicate/o MName FDmat
	variable ysize
	ysize = dimsize(MName,1)	
	Variable xdelta, xsize, xstart
	xsize = dimsize(MName,0)
	xdelta = dimdelta(MName,0)
	xstart = dimoffset(MName,0)
	Make/N=(xsize)/D/O FDwave
	SetScale/P x xstart,xdelta,"", FDwave
	
//	Make/N=201/D/O Gwindow1
//	setscale/P x -(100*xdelta), (xdelta), Gwindow1  
//	variable sumexp

	variable gauusian_br
	variable EF

	
	
	wave au_efw
	wave au_resow
	variable/G temp_G
	
		variable ii=0

	Do
//		FDwave = 1/(1+exp((x-au_EFw[ii])/(temp_G/11600)))
		EF = au_EFw[ii]
		gauusian_br = (au_resow[ii])^2 /4 /ln(2)
		Convolution1(FDwave, EF, gauusian_br)		
		FDmat[][ii] = FDwave[p]
	
	ii = ii +1
	while (ii<ysize)
	
	duplicate/o MName Divresult
	
	Divresult = MName/ (FDmat+bglevel)
	
	DO_ShwW_TmpwaveUpdate()

	
End	



Function Convolution1(yw, EF, gauusian_br)
wave yw
variable EF, gauusian_br

	Variable xdelta, xsize, xstart
	xsize = dimsize(yw,0)
	xdelta = dimdelta(yw,0)
	xstart = dimoffset(yw,0)
	
	make/D/O/N=(xsize) xw
	xw= xstart + p * xdelta
	
	Make/N=201/D/O Gwindow1
	setscale/P x -(100*xdelta), (xdelta), Gwindow1  
	variable sumexp
	Gwindow1 = exp(-x^2/gauusian_br)
	sumexp = sum(Gwindow1, -inf,inf)
	Gwindow1 /= sumexp
	
	variable ywNpnts, Extpnts
	Extpnts = round(gauusian_br/xdelta*2)/10
	Extpnts = max(Extpnts,10)
	ywNpnts = xsize + 4*Extpnts
	Make/D/O/N=(ywNpnts)   yWave
	setscale/P x (xw[0]-2*xdelta*Extpnts), xdelta, yWave
	
	variable/G temp_G
	yWave = 1/(1+exp((x-EF)/(temp_G/11600)))
	
	
	// Convolve yWave with gaussy
	convolve /A Gwindow1, yWave

	yw = yWave(xw[p])

	
End


Function TryExists(coef)
wave coef

	print waveexists(coef)
	
end





Function MatFitting_edgeC(mat2d, temp, ireso)
Wave mat2d
Variable temp
Variable ireso

	Make/N=6/O coef_edge
	
	variable qsize = Dimsize(mat2D,1)
	variable qoffset = Dimoffset(mat2D,1)
	variable qstep = Dimdelta(mat2D,1)
	variable esize = Dimsize(mat2D,0)
	variable eoffset = Dimoffset(mat2D,0)
	variable estep = Dimdelta(mat2D,0)
	
	make/N=(qsize)/o EF_edge
	SetScale/P x (qoffset),(qstep),"", EF_edge
	
	make/N=(esize)/o ewave1d
	SetScale/P x (eoffset),(estep),"", ewave1d
	
	variable ii =0 
	variable fitA, fitB
	fitA = hcsr(A)
	fitB = hcsr(B)
	
	if (fitA >= fitB)
		DoAlert 0, "CursolA has to be located at lower energy than CursolB!!"
		return -1
	endif 

	ewave1d[] =  mat2d[p][0]
		
	Dowindow  W_edgefit
	if (V_flag==0)
			display/N=W_edgefit
	endif
	Dowindow/F  W_edgefit
	Appendtograph/W=W_edgefit ewave1d
	Cursor A, ewave1d, fitA 
	Cursor B, ewave1d, fitB 

	variable efvalue
	ii = 0
	Do 
		Dowindow/F  W_edgefit
		ewave1d[] =  mat2d[p][ii]	
 		WaveFitting_edgeC(ewave1d, temp, ireso, 0)
 		efvalue = coef_edge[2]
 		EF_edge[ii] = efvalue
 		ii+=1
 	while(ii< qsize)
 	

end



Function  WaveFitting_edgeC(WName, temp, ireso, flag_ofslope)
Wave WName
Variable temp
Variable ireso
variable flag_ofslope
//String coef_edgename

	Make/N=6/O coef_edge
	//Redimension/N=6 coef

	Variable startE, EndE
	startE = pnt2x(WName, pcsr(A))
	EndE = pnt2x(WName, pcsr(B))
	
	if (startE >= EndE)
		DoAlert 0, "CursolA has to be located at lower energy than CursolB!!"
		return -1
	endif 	
	
	Variable EF
	Variable resolution
	Variable hight, slope, offseth, offsetsl
	Variable xdelta
	xdelta = dimdelta(WName,0)
	
	duplicate/o WName, FDcurve
	
	
	Variable/G coef_flag
	Variable/G showFD_flag
	
		
	//////////////  initial guess  ////////////////
	////////////    offset  ///////////
	
	offseth =  sum (WName, (EndE-5*xdelta),(EndE+5*xdelta) )/11
	
	/////// EF ///////

	make/N=30/O FDtestC
	variable ii=0
	Variable DetectE, RangeE
	RangeE = (EndE-startE)/30
	DetectE = startE + RangeE/2
	SetScale/P x DetectE,RangeE,"", FDtestC
	
	Do
		FDtestC[ii] = sum (WName, (DetectE-RangeE/2),(DetectE+RangeE/2)) / (RangeE/xdelta+1) 
		FDtestC[ii] =	FDtestC[ii] - offseth
		DetectE = DetectE + RangeE
		ii = ii +1
	while(ii<30)

	ii=0
	Do
		EF = startE + RangeE/2 + ii*RangeE
		ii= ii +1
	while (FDtestC[ii-1] > (FDtestC[0]/2))
	
	/////// hight  & slope ///////
	Variable LstartP, LEndP
	LstartP= x2pnt(WName, startE)
	LEndP = x2pnt(WName, (startE+(EF-startE)/3*2))
//	print startE, EF, LstartP,LEndP
	CurveFit/NTHR=0/Q=1 line WName[LstartP,LEndP] 
	wave w_coef
	hight =  w_coef[0]
	slope = w_coef[1]

	LstartP= x2pnt(WName, (EndE-(EndE-EF)/3*2))
	LEndP = x2pnt(WName, (EndE+xdelta*20))
	CurveFit/NTHR=0/Q=1 line WName[LstartP,LEndP] 
	if (flag_ofslope==0)
	offseth = sum (WName, (EndE-5*xdelta),(EndE+5*xdelta) )/11
	offsetsl = 1
	else
	offseth =  w_coef[0]
	offsetsl = w_coef[1]
	endif
	
//	if (coef_flag==0)
	coef_edge[0] = hight - offseth
	coef_edge[1] = slope -offsetsl
	coef_edge[2] = EF
	coef_edge[3] = offseth
	coef_edge[4] = offsetsl
//	endif

	FDcurve = (coef_edge[0] + coef_edge[1] *x)*(1/(1+exp((x-coef_edge[2] )/(temp/11600)))) + coef_edge[3] + coef_edge[4] *x
	
	coef_edge[5] = temp/11600*10
	FuncFit/NTHR=0/Q EdgeFunction coef_edge  WName[pcsr(A),pcsr(B)] /D 
		
	coef_edge[5] = (ireso/2)^2/ln(2)

	Variable/G temp_G
	temp_G = temp	
	FuncFit/NTHR=0/Q EdgeConvoluted coef_edge WName[pcsr(A),pcsr(B)] /D


	Make/N=201/D/O Gwindow1
	setscale/P x -(100*xdelta), (xdelta), Gwindow1  
	variable sumexp
	Gwindow1 = exp(-x^2/coef_edge[5])
	sumexp = sum(Gwindow1, -inf,inf)
	Gwindow1 /= sumexp
	
	if (showFD_flag==0)
	FDcurve = (coef_edge[0] + coef_edge[1] *x)*(1/(1+exp((x-coef_edge[2] )/(temp/11600)))) + coef_edge[3] + coef_edge[4] *x
	convolve /A Gwindow1, FDcurve
	endif
	
	resolution = sqrt(coef_edge[5]*ln(2))*2
	print "resolution", resolution
	print "Fermi energy", coef_edge[2]

End


Function  WaveFitting_edge_ini(WName, coef, temp, ireso,startE,EndE)
Wave WName
Wave coef
Variable temp
Variable ireso
Variable startE, EndE

	Redimension/N=6 coef

	Variable EF
	Variable resolution
	Variable hight, slope, offseth, offsetsl
	Variable xdelta
	xdelta = dimdelta(WName,0)
	
	duplicate/o WName, FDcurve
	
		
	////////////    offset  ///////////
	
	offseth =  sum (WName, (EndE-5*xdelta),(EndE+5*xdelta) )/11
	
	/////// EF ///////
	make/N=30/O FDtestC
	variable ii=0
	Variable DetectE, RangeE
	RangeE = (EndE-startE)/30
	DetectE = startE + RangeE/2
	SetScale/P x DetectE,RangeE,"", FDtestC
	
	Do
		FDtestC[ii] = sum (WName, (DetectE-RangeE/2),(DetectE+RangeE/2)) / (RangeE/xdelta+1) 
		FDtestC[ii] =	FDtestC[ii] - offseth
		DetectE = DetectE + RangeE
		ii = ii +1
	while(ii<30)

	ii=0
	Do
		EF = startE + RangeE/2 + ii*RangeE
		ii= ii +1
	while (FDtestC[ii-1] > (FDtestC[0]/2))
	
	/////// hight  & slope ///////
	Variable LstartP, LEndP
	LstartP= x2pnt(WName, startE)
	LEndP = x2pnt(WName, (EF- RangeE*2))
	CurveFit/NTHR=0/Q=1 line WName[LstartP,LEndP] 
	wave w_coef
	hight =  w_coef[0]
	slope = w_coef[1]
	
	LstartP= x2pnt(WName, EF +RangeE*2)
	LEndP = x2pnt(WName, EndE)
	CurveFit/NTHR=0/Q=1 line WName[LstartP,LEndP] 
	offseth =  w_coef[0]
	offsetsl = w_coef[1]
	
	
	coef[0] = hight
	coef[1] = slope
	coef[2] = EF
	coef[3] = offseth
	coef[4] = offsetsl

	FDcurve = (coef[0] + coef[1] *x)*(1/(1+exp((x-coef[2] )/(temp/11600)))) + coef[3] + coef[4] *x
	
	coef[5] = temp/11600*10
//	coef[5]=0.001
	FuncFit/NTHR=0/Q EdgeFunction coef  WName[pcsr(A),pcsr(B)] /D 
End


Function  WaveMaking_edgeC(WName, coef, temp, ireso)
Wave WName
Wave coef
Variable temp
Variable ireso

//	Variable startE, EndE
//	startE = pnt2x(WName, pcsr(A))
//	EndE = pnt2x(WName, pcsr(B))
	
//	if (startE >= EndE)
//		DoAlert 0, "CursolA has to be located at lower energy than CursolB!!"
//		return -1
//	endif 	
	
	Variable EF
	Variable resolution
	Variable hight, slope, offseth, offsetsl
	Variable xdelta
	xdelta = dimdelta(WName,0)
	
	duplicate/o WName, FDcurve_raw
	duplicate/o WName, FDcurve

	
	
//	Variable/G coef_flag
//	Variable/G showFD_flag
	
		

	FDcurve_raw= (coef[0] + coef[1] *x)*(1/(1+exp((x-coef[2] )/(temp/11600)))) + coef[3] + coef[4] *x
	
//	coef[5] = temp/11600*10
//	FuncFit/NTHR=0/Q EdgeFunction coef  WName[pcsr(A),pcsr(B)] /D 
	
	
	coef[5] = ireso

//	Variable/G temp_G
//	temp_G = temp	
//	FuncFit/NTHR=0 EdgeConvoluted coef WName[pcsr(A),pcsr(B)] /D
	
	Make/N=201/D/O Gwindow1
	setscale/P x -(100*xdelta), (xdelta), Gwindow1  
	variable sumexp
	Gwindow1 = exp(-x^2/   (ireso/2)^2 *ln(2)   )
	sumexp = sum(Gwindow1, -inf,inf)
	Gwindow1 /= sumexp
	
	
	FDcurve = (coef[0] + coef[1] *x)*(1/(1+exp((x-coef[2] )/(temp/11600)))) + coef[3] + coef[4] *x
	convolve /A Gwindow1, FDcurve
	
//	resolution = sqrt(coef[5]*ln(2))*2
	print "resolution", ireso
	print "Fermi energy", coef[2]

End



Function trywavecall(wn,para)
wave wn
variable para

	print waveexists(wn)


end


Function MatAreaSum(Mname,snum,enum)
wave Mname
Variable snum,enum

	variable xsize, ysize
	xsize = dimsize(Mname,0)
	ysize = dimsize(Mname,1)
	print xsize, ysize
	variable xoffset, yoffset
	xoffset = dimoffset(Mname,0)
	yoffset = dimoffset(Mname,1)
	print xoffset,yoffset
	variable xdelta, ydelta
	xdelta = dimdelta(Mname,0)
	ydelta = dimdelta(Mname,1)
	print xdelta, ydelta
	
	make/o/N=(xsize) addwave, addwavefin
	SetScale/P x (xoffset),(xdelta),"", addwave
	SetScale/P x (xoffset),(xdelta),"", addwavefin
	
	addwavefin=0


	variable ii
	ii=snum
	Do
		addwave = Mname[p][ii]
		addwavefin = addwavefin +addwave
		ii = ii +1
	while ((ii+1)<enum)
	
	display addwavefin
	
end
