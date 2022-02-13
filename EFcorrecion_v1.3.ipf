#pragma TextEncoding = "Shift_JIS"
#pragma rtGlobals=3		// Use modern global access method and strict wave access.

////////////////////////////////////////////////
//		EF correcltion program
//		2017/12/16			ver1.0.1
//								by S. Soma                      
// 	Thie program first has been made for SES2002 data @BL.
//		You can modify 2D and 3D matrix.
//		there are two direction of EF moving: one is along slit, and other is along hv or tilt angle.
//		Word of 'tilt' comes from the specific sample manipurator @ BL2 and BL28 in PF
//		but, basically the 'tilt' direction supposes one perpendicular to slit
//  
//		For 3D matrix, I suggest using GS_theta window for hv (tilt) and GS_phi for slit 
//		In either window, EF line superimposed to adjust 
//			
//		ver 1.0.1  UmEmpty　ボタンを追加 //legacy? none of such in ver 1.1.2
//    ver 1.1.0  EF_line analysis for arbitrary 2Dmat
//						Select the matrix of the topwindow with the target button. cursors A and B are added to the topwindow.
//		ver 1.1.1  	Correction 2D　button
//						Correction 3Dhv　button
//		ver 1.1.2	Correction 3Dslit　button
//
//		ver 1.2 		Out of range error is fixed for EFshift3D_hv
//		(2021/8/24)	Ohterwise matrix never saved when it is big size one.
//
//		ver 1.3		The method of enrgy shift of  matrix (2D or 3D) has been changed to 
//		(2021/10/23)interporatoin so that the parameter of deng has gone.
//						Global variables moved to subfolder "EFCorrection"
//						function of saving to different matrix is equipped to Correction 2D, 3Dslit, 3Dhv
/////////////////////////////////////////////////////////////////////////////////////

Function Setup_EFcorr()

	DFREF dfr
	
	if (DataFolderRefStatus(dfr) ==0)
		NewDataFolder/O root:EFCorrection
	endif
	
	DFREF dfr = root:EFCorrection

	Variable/G dfr:EF_curve_center=0.5
	Variable/G dfr:EF_curve_curvture=0
	Variable/G dfr:EF_curve_sft=0
	Variable/G dfr:EF_curve_slp=0
	Variable/G dfr:EF_deng = 4
	String/G dfr:EF_TargetWindow
	make/o/N=101 dfr:EF_line

End


Window EFcorrection_slit() : Panel
	PauseUpdate; Silent 1		// building window...
	Setup_EFcorr()
	NewPanel /W=(1180,141,1341,397)
	ModifyPanel cbRGB=(65535,43690,0,19861)
	Button EFcorr_makeEFline_button,pos={4.00,5.00},size={82.00,27.00},proc=EFcor_Button_MakeEFline,title="EFline"
	Button EFcorr_RemoveEF_button,pos={92.00,5.00},size={21.00,23.00},proc=EFcor_Button_RemoveEFline,title="R"
	Button EFcorr_RemoveEF_button,fColor=(65535,54607,32768)
	Button EFcorr_AppendEF_button,pos={116.00,5.00},size={21.00,23.00},proc=EFcor_Button_AppendEFline,title="A"
	Button EFcorr_AppendEF_button,fColor=(65535,16385,16385)
	SetVariable EFcorr_curvecenter_setvar,pos={8.00,53.00},size={92.00,18.00},proc=EFcor_SetVar_EFcurve,title="cen"
	SetVariable EFcorr_curvecenter_setvar,fSize=12
	SetVariable EFcorr_curvecenter_setvar,limits={0,1,0.01},value= root:EFCorrection:EF_curve_center
	SetVariable EFcorr_curvecurvture_setvar,pos={11.00,91.00},size={90.00,18.00},proc=EFcor_SetVar_EFcurve,title="crv"
	SetVariable EFcorr_curvecurvture_setvar,fSize=12
	SetVariable EFcorr_curvecurvture_setvar,limits={-0.01,0.01,1e-05},value= root:EFCorrection:EF_curve_curvture
	Button EFcorr_EFcorrection3Dslit_button,pos={10.00,165.00},size={138.00,31.00},proc=EFcor_Button_EFshift3Dslit,title="Correction 3Dslit"
	Button EFcorr_EFcorrection3Dslit_button,fSize=16,fColor=(40969,65535,16385)
	SetVariable EFcorr_curveheight_setvar,pos={11.00,112.00},size={90.00,18.00},proc=EFcor_SetVar_EFcurve,title="hgt"
	SetVariable EFcorr_curveheight_setvar,fSize=12
	SetVariable EFcorr_curveheight_setvar,limits={-1,1,0.002},value= root:EFCorrection:EF_curve_sft
	SetVariable EFcorr_curveslope_setvar,pos={11.00,72.00},size={88.00,18.00},proc=EFcor_SetVar_EFcurve,title="slp"
	SetVariable EFcorr_curveslope_setvar,fSize=12
	SetVariable EFcorr_curveslope_setvar,limits={-0.02,0.02,0.001},value= root:EFCorrection:EF_curve_slp
	TitleBox title0,pos={14.00,229.00},size={95.00,19.00}
	TitleBox title0,labelBack=(65535,65535,65535),variable= GS_mat3Dname
	Button EFcorr_SetTarget_button,pos={7.00,34.00},size={47.00,16.00},proc=EFcor_Button_SetTarget,title="Target"
	Button EFcorr_SetTarget_button,fSize=10
	TitleBox title1,pos={67.00,32.00},size={54.00,18.00}
	TitleBox title1,labelBack=(65535,65535,65535),fSize=8
	TitleBox title1,variable= root:EFCorrection:EF_TargetWindow
	Button EFcorr_EFcorrection3Dhv_button,pos={10.00,197.00},size={138.00,31.00},proc=EFcor_Button_EFshift3Dhv,title="Correction 3Dhv"
	Button EFcorr_EFcorrection3Dhv_button,fSize=16,fColor=(40969,65535,16385)
	Button EFcorr_EFcorrection2D_button,pos={10.00,133.00},size={138.00,31.00},proc=EFcor_Button_EFcorction2D,title="Correction 2D"
	Button EFcorr_EFcorrection2D_button,fSize=16,fColor=(49151,49152,65535)
EndMacro


Function EFcor_MakeEFline(mat2d)
wave mat2d

	DFREF dfr = root:EFCorrection


	if (waveexists(mat2d)==0)
	return -1
	endif
	
	variable pnts = Dimsize(mat2d,1)
	variable xoffset = Dimoffset(mat2d,1)
	variable xstep = Dimdelta(mat2d,1)

	make/D/N=(pnts)/o dfr:EF_line
	wave EF_line = dfr:EF_line
	SetScale/P x xoffset,xstep,"", EF_line

	String winame = winname(0,1)

	variable xA,xB,yA,yB
	xA = vcsr(A, winame)
	xB = vcsr(B, winame)
	yA = hcsr(A, winame)
	yB = hcsr(B, winame)

 	EF_line = (yB-yA)/(xB-xA)*(x-xA) + yA

end


Function EFcor_CurveEFline(mat2d)
wave mat2d

	DFREF dfr = root:EFCorrection
	NVAR EF_curve_center=dfr:EF_curve_center
	NVAR EF_curve_curvture=dfr:EF_curve_curvture
	NVAR EF_curve_sft=dfr:EF_curve_sft
	NVAR EF_curve_slp=dfr:EF_curve_slp
	
	if (waveexists(mat2d)==0)
		return -1
	endif
	
	variable pnts = Dimsize(mat2d,1)
	variable xoffset = Dimoffset(mat2d,1)
	variable xstep = Dimdelta(mat2d,1)

	make/D/N=(pnts)/o dfr:EF_line
	wave EF_line = dfr:EF_line
	SetScale/P x xoffset,xstep,"", EF_line

	String winame = winname(0,1)

	variable xA,xB,yA,yB
	xA = vcsr(A, winame)
	xB = vcsr(B, winame)
	yA = hcsr(A, winame)
	yB = hcsr(B, winame)
	
	variable slp
	slp = (yB-yA)/(xB-xA) 
	
 	EF_line = slp*(x-xA) + yA
 	
 	variable cen = EF_curve_center
	variable crvF = EF_curve_curvture
 	variable range = xstep * pnts
 	
 	EF_line = EF_line + (x-xoffset-cen*range)^2 * crvF +(x-EF_curve_center)* EF_curve_slp+ EF_curve_sft


end


Function EFcor_EFshift3D(mat3d)
wave mat3d
	
	//tic()

	DFREF dfr = root:EFCorrection
	wave EF_line = dfr:EF_line
		
	if (waveexists(EF_line)==0)
	 return -1
	endif
	
	duplicate/o EF_line EF_shift,endpoint
	EF_shift = EF_line - wavemax(EF_line)
	endpoint = round(EF_shift/Dimdelta(mat3d,0))
	
	make/N=(Dimsize(mat3d,0))/D/O srcwave1d, srcwave1x, newwave1x
	duplicate/o mat3d, sftmat3d
	srcwave1x = Dimoffset(mat3d,0) + DimDelta(mat3d,0)*p
	
	variable tline=0, philine=0
	
	Do

		Do
			srcwave1d = mat3d[p][tline][philine]
			newwave1x = srcwave1x-EF_shift[tline]
		
			Interpolate2/T=2/E=2/Y=ipwave1d/X=srcwave1x/I=3 newwave1x,srcwave1d

			ipwave1d[0,(-endpoint[tline])]=srcwave1d[0]
	
			sftmat3d[][tline][philine] = ipwave1d[p]
			
			tline=tline +1
		
		while(tline< (Dimsize(mat3d,1)-1))
		
		philine=philine+1
		tline =0
		
	while(philine< (Dimsize(mat3d,2)-1))
	
	mat3d = sftmat3d
	
	killwaves sftmat3d
	killwaves srcwave1d, srcwave1x, newwave1x
	killwaves EF_shift,endpoint

	//toc()

end



Function EFcor_EFshift3D_hv(mat3d,hvsft)
wave mat3d
wave hvsft


	if (waveexists(hvsft)==0)
	 return -1
	endif
	
	duplicate/o hvsft EF_shift,endpoint

	EF_shift = hvsft - wavemax(hvsft)
	endpoint = round(EF_shift/Dimdelta(mat3d,0))
	
	make/N=(Dimsize(mat3d,0))/D/O srcwave1d, srcwave1x, newwave1x
	duplicate/o mat3d, sftmat3d
	srcwave1x = Dimoffset(mat3d,0) + DimDelta(mat3d,0)*p
	
	variable tline=0, hvline=0
	
	
	Do
		hvline=0
		Do
			srcwave1d = mat3d[p][tline][hvline]
			newwave1x = srcwave1x-EF_shift[hvline]
		
			Interpolate2/T=2/E=2/Y=ipwave1d/X=srcwave1x/I=3 newwave1x,srcwave1d

			ipwave1d[0,(-endpoint[hvline])]=srcwave1d[0]
			
			sftmat3d[][tline][hvline] = ipwave1d[p]
			
			hvline=hvline +1
		
		while(hvline< (Dimsize(mat3d,2)-1))
		
		tline=tline+1
		
	while(tline< (Dimsize(mat3d,1)-1))
	
	mat3d = sftmat3d
	
	killwaves sftmat3d
	killwaves srcwave1d, srcwave1x, newwave1x
	killwaves EF_shift,endpoint

	//toc()


end


Function EFcor_EFshift2D(mat2d)
wave mat2d

	DFREF dfr = root:EFCorrection
	wave EF_line = dfr:EF_line

	if (waveexists(EF_line)==0)
	 return -1
	endif
	
	duplicate/o EF_line EF_shift,endpoint
	EF_shift = EF_line - wavemax(EF_line)
	endpoint = round(EF_shift/Dimdelta(mat2d,0))
	
	make/N=(Dimsize(mat2d,0))/D/O srcwave1d, srcwave1x, newwave1x
	duplicate/o mat2d, sftmat
	srcwave1x = Dimoffset(mat2d,0) + DimDelta(mat2d,0)*p
	
	variable tline =0
	

	Do
		srcwave1d = mat2d[p][tline]
		newwave1x = srcwave1x-EF_shift[tline]
		
		Interpolate2/T=2/E=2/Y=ipwave1d/X=srcwave1x/I=3 newwave1x,srcwave1d

		ipwave1d[0,(-endpoint[tline])]=srcwave1d[0]
	
		sftmat[][tline] = ipwave1d[p]
		tline=tline +1
		
	while(tline< (Dimsize(mat2d,1)-1))
	
	
	mat2d = sftmat
	
	killwaves srcwave1d, srcwave1x, newwave1x
	killwaves sftmat
	

end



	
	
Function FillNanCell(mat3d)
wave mat3d

	variable esize = Dimsize(mat3d,0)
	variable qsize = Dimsize(mat3d,1)
	
	make/N=(esize,qsize)/D/O mat2d
	mat2d[][] = mat3d[p][q][0]
	
	
	variable ii=0, jj=0
	variable unull,dnull
	variable matval, nullflag
	
	ii=0
	
	Do
		dnull=esize
		Do
			dnull-=1
			matval=mat2d[dnull][ii]
			nullflag = numtype(matval)
		while (nullflag==2)
		if (dnull<(esize-1))
			mat3d[(dnull+1),(esize-1)][ii][] = mat3d[dnull][ii][r]
		endif
		
		unull=0
		Do
			matval=mat2d[unull][ii]
			nullflag = numtype(matval)
			unull+=1
		while (nullflag==2)
		
		if ((unull-1)>0)
	//		mat2d[0,(unull-2)][ii] = mat2d[unull-1][ii]
			mat3d[0,(unull-2)][ii][] = mat3d[unull-1][ii][r]
		endif
	
	ii=ii+1
	while(ii<qsize)
End




Function EFcor_Button_MakeEFline(ctrlName) : ButtonControl
	String ctrlName
	
	String MNlist
	String TopMatName	
	
	DFREF dfr = root:EFCorrection
	
	SVAR EF_TargetWindow = dfr:EF_TargetWindow

	
	MNlist = WaveList("*",";","DIMS:2,WIN:")
	TopMatName=stringfromlist(0,MNlist)		
	
	EF_TargetWindow = TopMatName
	EFcor_MakeEFline($TopMatName)
	
End

Function EFcor_Button_AppendEFline(ctrlName) : ButtonControl
	String ctrlName
	String winnm = Winname(0,1)
	string tlist
	
	DFREF dfr = root:EFCorrection
	wave EF_line = dfr:EF_line
	svar EF_TargetWindow = dfr:EF_TargetWindow


	
	NVAR EF_curve_sft=dfr:EF_curve_sft
	NVAR EF_curve_slp = dfr:EF_curve_slp
	NVAR EF_curve_center = dfr:EF_curve_slp
			
			
		EFcor_CurveEFline($EF_TargetWindow)
		EF_line = EF_line + (x-EF_curve_center)* EF_curve_slp+ EF_curve_sft		
	
		tlist = TracenameList(winnm,";",1)
		if (StringMatch(tlist,"EF_line*")==0)
			AppendToGraph/VERT/W=$winnm EF_line		
		endif

	
End

Function EFcor_Button_RemoveEFline(ctrlName) : ButtonControl
	String ctrlName
	String winnm = Winname(0,1)
	string tlist
	DFREF dfr = root:EFCorrection
	wave EF_line = dfr:EF_line
	
	tlist = TracenameList(winnm,";",1)
		if (StringMatch(tlist,"EF_line*")==1)
			RemoveFromGraph/W=$winnm EF_line
		endif

End



Function EFcor_SetVar_EFcurve(ctrlName,varNum,varStr,varName) : SetVariableControl
	String ctrlName
	Variable varNum
	String varStr
	String varName
	
	DFREF dfr = root:EFCorrection
	wave EF_line = dfr:EF_line
	
	SVAR EF_TargetWindow = dfr:EF_TargetWindow

	EFcor_CurveEFline($EF_TargetWindow)
//	EF_line = EF_line + (x-EF_curve_center)* EF_curve_slp+ EF_curve_sft


End

Function EFcor_Button_EFshift3Dslit(ctrlName) : ButtonControl
	String ctrlName
	String/G GS_mat3DName
	
	DFREF dfr = root:EFCorrection

	duplicate/o $GS_mat3DName mat3d
	print GS_mat3DName, "copy to mat3d"
	
	EFcor_EFshift3D(mat3d)
	//FillNanCell(mat3d)

	variable yesno
	Prompt yesno, "Do you want to overwrite to the original 3Dmatrix of ["+GS_mat3DName + "] ?", popup, "yes;no"
	DoPrompt "Overwite", yesno
		
			if (V_Flag)
			return -1
			endif
		
		if (yesno==1)
			duplicate/o mat3d $GS_mat3DName
		elseif (yesno==2)
			string newmatname = GS_mat3DName + "_sft"
			Prompt newmatname, "Enter the matrixname to save"
			Doprompt "DataLoad", newmatname
			duplicate/o mat3d $newmatname
			
		endif
	
	killwaves mat3d
	
End


Function EFcor_Button_SetTarget(ctrlName) : ButtonControl
	String ctrlName
	
	DFREF dfr = root:EFCorrection
	SVAR EF_TargetWindow = dfr:EF_TargetWindow

	String MNlist
	String TopMatName	
	
	MNlist = WaveList("*",";","DIMS:2,WIN:")
	TopMatName=stringfromlist(0,MNlist)	
	ctrlName =TopMatName
	EF_TargetWindow = TopMatName
	
	////// Cursor A, B Location  //////////
	variable esize = Dimsize($TopMatName,0)
	variable eoffset = DimOffset($TopMatName,0)
	variable edelta = Dimdelta($TopMatName,0)
	variable tsize = Dimsize($TopMatName,1)
	variable toffset = DimOffset($TopMatName,1)
	variable tdelta = Dimdelta($TopMatName,1)
	
	Cursor/I A, $TopMatName, (eoffset + esize*0.8*edelta), (toffset + tsize*0.1*tdelta)
	Cursor/I B, $TopMatName, (eoffset + esize*0.8*edelta), (toffset + tsize*0.9*tdelta)

End








Function EF_autotrace(stepnum,xoy,swidth)
variable stepnum
variable xoy
variable swidth
variable/G AT_StartA, AT_EndA
variable/G AT_StartE, AT_EndE
//variable/G AT_profilewidth = 3

make/N=100/o AT_profilew

	AT_StartA =  vcsr(A,"")
	AT_EndA =  vcsr(B,"")
	AT_StartE =  xcsr(A,"")
	AT_EndE =  xcsr(B,"")


 	if ((xoy!=1)&&(xoy!=0))
 		print "xoy is invalid"
 		return -1
 	endif

	make/N=(stepnum+1)/D/O autotraceX, autotraceY
	autotraceX=nan
	autotraceY=nan
	
	
	variable step
	variable iniSlice, inilevel
	
	if (xoy==0)
			step = (AT_EndA - AT_StartA)/stepnum
			iniSlice = AT_StartA
			inilevel = AT_StartE
	elseif (xoy==1)
			step = (AT_EndE - AT_StartE)/stepnum
			iniSlice = AT_StartE
			inilevel = AT_StartA
	endif
			
	variable slice
	slice = iniSlice
//	swidth = AT_profilewidth
	
	// initial fitting //
		// 最初のprofile を取得
	EF_getspectrum(slice, xoy, swidth)
	
		// fitting の範囲を設定
		//  ピークが+0から再び+0になる範囲に設定
	variable ax, bx // fit range (ax<bx)
	variable val=0, nn=0, add=1
	variable xval, wval
	variable wstep, iniP
	wstep = dimdelta(AT_profilew,0)
	iniP = inilevel
	ax = EF_findZeroL(AT_profilew, iniP)
	bx = EF_findZeroR(AT_profilew, iniP)
	

	CurveFit/M=2/W=0/Q lor, AT_profilew(ax,bx)/D
	wave w_coef
	
	autotraceX[0] = w_coef[2]
	autotraceY[0] = slice
	
	// Fitting ルーチン
	nn = 1
	variable preP
	Do
		slice = iniSlice + nn*step
		EF_getspectrum(slice, xoy, swidth)
		preP = autotraceX[(nn-1)]
		ax = EF_findZeroL(AT_profilew, preP)
		bx = EF_findZeroR(AT_profilew, preP)
		CurveFit/N/W=2/Q lor, AT_profilew(ax,bx)/D
		autotraceX[nn] = w_coef[2]
		autotraceY[nn] = slice
		nn = nn +1
	while (nn < (stepnum+1))
	
	if (xoy==0)
		duplicate/o autotraceX autotraceE
		duplicate/o autotraceY autotraceA
	elseif (xoy==1)
		duplicate/o autotraceX autotraceA
		duplicate/o autotraceY autotraceE
	endif


end

Function EF_getspectrum(sliceA, xoy, swidth)
variable sliceA, xoy, swidth
string MNlist, TopMatName
String/G EF_TargetWindow
 
 	if ((xoy!=1)&&(xoy!=0))
 		print "xoy is invalid"
 		return -1
 	endif
 	
 	// 解析のためのmatrix をコピー
//	dowindow/F Show2ndDrv
//	MNlist = WaveList("*",";","DIMS:2,WIN:")
//	TopMatName=stringfromlist(0,MNlist)	
	duplicate/o $EF_TargetWindow datamat
	
	// datamat の xoy (x or y)方向を同じスケールのwave: AT_profilewを生成
	variable xstart, xstep, xsize, xend
	xsize = dimsize(datamat, xoy)
	make/N=(xsize)/o AT_profilew
	xstart = dimoffset(datamat, xoy)
	xstep = dimdelta(datamat, xoy)
	xend = xstart + xsize*xstep
	SetScale/P x xstart, xstep,"", AT_profilew
	
	//AT_profilewの直交方向についてdatametの情報取得
	variable nxoy = (xoy!=1)  // xoyの0,1を逆転
	variable ystart, ystep, ysize, yend
	ysize = dimsize(datamat, nxoy)
	ystart = dimoffset(datamat, nxoy)
	ystep = dimdelta(datamat, nxoy)
	yend = ystart + ysize*ystep
	
	// swidthが何本のsliceになるか計算:pn
	variable pn
	pn = round(swidth/ystep)
	//sliceAの位置がgridの左右どちら側にあるかを判定
	variable leftright	
	variable LR_flag  // 左側なら-1、右側なら+1
	leftright = mod((sliceA-ystart),ystep) /ystep
	if ((leftright>=0)&&(leftright<0.5))
		LR_flag = -1
	elseif ((leftright>=0.5)&&(leftright<1))
		LR_flag = 1
	endif
	
	// sliceAが右側にあれば、0, -1, +1, -2...の順に
	// 左側にあれば、0, +1, -1, +2の順に slice を加算
	duplicate AT_profilew addwave
	variable slice
	variable nn=0, val=0, add=1
	AT_profilew = 0

	Do 
		val = val + nn*add*LR_flag  
		slice = sliceA + val*ystep	

		if (xoy==0)
			addwave= datamat[p](slice)
		elseif (xoy==1)
			addwave = datamat(slice)[p]
		endif
		
		AT_profilew = AT_profilew + addwave
		
		add =add *(-1)
		nn = nn +1
	while (nn<pn)
	killwaves addwave
	
end


function EF_findZeroL(ww, xini)
	wave ww
	variable xini
//	variable ax
	variable val=0, nn=0 //, add=1
	variable xval, wval
	variable wstep
	wstep = dimdelta(ww,0)
	
	Do 
		xval = xini - nn*wstep
		wval = ww(xval)
		nn = nn +1	
	while ( wval < 0)
	return xval
end

function EF_findZeroR(ww, xini)
	wave ww
	variable xini
//	variable ax
	variable val=0, nn=0 //, add=1
	variable xval, wval
	variable wstep
	wstep = dimdelta(ww,0)
	
	Do 
		xval = xini + nn*wstep
		wval = ww(xval)
		nn = nn +1	
	while ( wval < 0)
	return xval
end



Function EFcor_Button_EFcorction2D(ctrlName) : ButtonControl
String ctrlName
	
	DFREF dfr = root:EFCorrection
	
	SVAR EF_TargetWindow = dfr:EF_TargetWindow
	wave ef_line = dfr:ef_line
//	Variable/G EF_deng
	duplicate/o $EF_TargetWindow mat2d
	
	EFcor_EFshift2D(mat2d)
	
	variable yesno
	Prompt yesno, "Do you want to overwrite to the original matrix of ["+EF_TargetWindow + "] ?", popup, "yes;no"
	DoPrompt "Overwite", yesno
		
			if (V_Flag)
			return -1
			endif
		
		if (yesno==1)
			duplicate/o mat2d $EF_TargetWindow
		elseif (yesno==2)
			string newmatname = EF_TargetWindow + "_sft"
			Prompt newmatname, "Enter the matrixname to save"
			Doprompt "DataLoad", newmatname
			duplicate/o mat2d $newmatname
			
			EFcor_DisplaySavedResult($newmatname)
		endif
	
	killwaves mat2d
	
	
	
End


Function EFshift2D_offset(mat2d,deng,shift)
wave mat2d
variable deng
variable shift

//wave EF_line

	variable esize = Dimsize(mat2d,0)
	variable qsize = Dimsize(mat2d,1)
	
	variable newesize = (esize-1)*deng + 1

	make/O/N=(newesize, qsize)  new2DWave
	CopyScales/i mat2d,new2DWave
	new2DWave=Interp2D(mat2d,x,y)


	variable estep = Dimdelta(new2DWave,0)
	//if (waveexists(EF_line)==0)
	 //return -1
	//endif
	//duplicate/o EF_line EF_pnts
	variable EF_pnts
	EF_pnts = round(shift/estep)
	
	duplicate/o new2DWave new2DWave_tmp
	new2DWave[][]=new2DWave_tmp[p+EF_pnts][q]
	killwaves new2DWave_tmp
	
	mat2d = Interp2D(new2DWave,x,y)
	killwaves new2DWave

end

Function EFcor_Button_EFshift3Dhv(ctrlName) : ButtonControl
	String ctrlName
	
	DFREF dfr = root:EFCorrection
	String/G GS_mat3DName
	
	duplicate/o $GS_mat3DName mat3d
	
	if (ItemsInList(WaveList("hvsft*",";",""))==0)
		DoAlert  0, "hvsft wave does not exist. You have to make hvsft wave."
		return -1
	endif
	
	String hvsftname
	Prompt hvsftname, "Choose hvsft wave",popup,WaveList("hvsft*",";","")
	Doprompt "hv energy shift", hvsftname
	
	if (V_flag)
		return -1
	endif
	
	EFcor_EFshift3D_hv(mat3d,$hvsftname)
	
	variable yesno
	Prompt yesno, "Do you want to overwrite to the original 3Dmatrix of ["+GS_mat3DName + "] ?", popup, "yes;no"
	DoPrompt "Overwite", yesno
		
	if (V_Flag)
		return -1
	endif
		
		if (yesno==1)
			duplicate/o mat3d $GS_mat3DName
		elseif (yesno==2)
			string newmatname = GS_mat3DName + "_sft"
			Prompt newmatname, "Enter the matrixname to save"
			Doprompt "DataLoad", newmatname
			duplicate/o mat3d $newmatname			
		endif
	
	
	killwaves mat3d
	
End


Function EFcor_DisplaySavedResult(mat)
wave mat

	String colorinfo  // given by min;max;colorname;rev
	string topwinname=WinName(0,1) //maybe the window of source matrix 
	
	colorinfo = EFcorr_CopyColorScale(topwinname) // return string list contined in 
	//ModifyImage (name of top image) ctab={cmin,cmax,$colorname,rev}


	Display /W=(257,227,588,493) 
	AppendImage mat	
	ModifyGraph swapXY=1	
	variable cmin = str2num(StringFromList(0, colorinfo , ";"))
	variable cmax = str2num(StringFromList(1, colorinfo , ";"))
	string colorname = StringFromList(2, colorinfo , ";")
	variable rev = str2num(StringFromList(3, colorinfo , ";"))

	string newname = NameofWave(mat)
	ModifyImage $newname ctab={cmin,cmax,$colorname,rev}

end

Function/S EFcorr_CopyColorScale(topwinname)
string topwinname

	string graphinfo = WinRecreation(topwinname,0)
	string line1 =greplist(graphinfo, "ctab",0, "\r")
	string matname, s0, smax,smin,color,rev
	variable vmax,vmin,vrev
	sscanf line1," ModifyImage %s ctab= {%s", matname,s0
	s0 = RemoveEnding(s0)
	smin = StringFromList(0, s0  ,",")
	smax = StringFromList(1, s0  ,",")
	color = StringFromList(2, s0  ,",")
	rev = StringFromList(3, s0  ,",")
	
	//print matname,smin,smax,color,rev
	
	if (CmpStr(smax,"*")==0)
		vmax=wavemax($matname)
		smax = num2str(vmax)
	endif
	
	if (CmpStr(smin,"*")==0)
		vmin=wavemin($matname)
		smin = num2str(vmin)
	endif
		
	
	return (smin+";"+smax+";"+color+";"+rev+";")
end