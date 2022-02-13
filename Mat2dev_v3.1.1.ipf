////////////////////////////////////////////////////////////////////////////////////////////////////////////
////																														/////
////	Second Derivative  v. 2.0																					/////
////	by Seigo Souma																									/////
////	v.1.0.2    2011/9/26    Macro 作成																				/////
////	v.1.0.3    2011/9/26    Changed the definition of the direction of differentiation for ARPES data.		
////  v.1.1    2012/12/22  Added a function that also smooths in the direction perpendicular to the current one (does not appear in the panel).																											/////
////  v.2.0    2013/11/2 	Added angle wavenumber conversion window, onsite combination, color panel, etc.	
////	v.2.1.1	2021/10/7		BandMap_normal: extremely faster and more stable than uhsi macro																					/////
////	v.3.0		2021/10/8  	Global variables moved to subfolder "SecondDeriv"		
////								"Mat2ndDev_Update_Mat2ndDev()"	function automatically update old files
////	v.3.1		2021/10/15	Tab-key cursor movement has been fixed to move from top to bottom
////								bug fix: The center line of the source matrix image is not displayed when the K-E button is pressed.																								/////
////	v.3.1.1	2021/10/18	bug fix: Save button function does not work
////								bug fix: Global variables are not created the first time SecondDreivative panel is called
////////////////////////////////////////////////////////////////////////////////////////////////////////////


Window SecondDerivative() : Panel

	Mat2ndDev_SetUP()
	
	PauseUpdate; Silent 1		// building window...
	NewPanel /W=(631,45,794,230)
	ModifyPanel cbRGB=(65535,32768,32768)
	SetDrawLayer UserBack
	SetDrawEnv fsize= 10
	DrawText 4,51,"GS 2ndO"
	SetDrawEnv fsize= 10
	DrawText 4,68,"GS 4thO"
	SetDrawEnv fsize= 10
	DrawText 4,84,"Binominal"
	SetDrawEnv fsize= 10
	DrawText 4,32,"OrigM"
	SetDrawEnv fsize= 10
	DrawText 45,113,"color"
	SetDrawEnv fsize= 10
	DrawText 45,122,"scale"
	SetDrawEnv fsize= 7
	DrawText 81,129,"min %"
	SetDrawEnv fsize= 7
	DrawText 120,129,"max %"
	SetDrawEnv fsize= 10
	DrawText 4,15,"DrvMode"
	SetDrawEnv fsize= 8
	DrawText 131,14,"SDoff"
	SetDrawEnv fsize= 10
	DrawText 115,142,"rvrs"
	SetDrawEnv fsize= 10
	DrawText 4,100,"Comb"
		SetVariable Mat2ndDev_setvar_mode,pos={51.00,3.00},size={29.00,13.00},proc=Mat2ndDev_SetVar_EDCMDCmode,title=" "
	SetVariable Mat2ndDev_setvar_mode,font="Helvetica Neue",fSize=8
	SetVariable Mat2ndDev_setvar_mode,limits={0,1,1},value= root:SecondDeriv:Mat2dv_mode
	TitleBox Mat2ndDev_title_modeName,pos={82.00,1.00},size={30.00,15.00}
	TitleBox Mat2ndDev_title_modeName,labelBack=(65535,65535,65535)
	TitleBox Mat2ndDev_title_modeName,font="Helvetica Neue",frame=0
	SetVariable Mat2ndDev_setvar_OriMN,pos={35.00,19.00},size={68.00,14.00},title=" "
	SetVariable Mat2ndDev_setvar_OriMN,value= root:SecondDeriv:Mat2dv_OriMN
	SetVariable Mat2ndDev_setvar_GS2num,pos={52.00,38.00},size={44.00,13.00},proc=Mat2ndDev_SetVar_ChangeSmthPara,title="p"
	SetVariable Mat2ndDev_setvar_GS2num,font="Helvetica"
	SetVariable Mat2ndDev_setvar_GS2num,limits={5,25,2},value= root:SecondDeriv:Mat2dv_pointnum2
	SetVariable Mat2ndDev_setvar_GS2rep,pos={98.00,38.00},size={56.00,13.00},proc=Mat2ndDev_SetVar_ChangeSmthPara,title="rep"
	SetVariable Mat2ndDev_setvar_GS2rep,font="Helvetica"
	SetVariable Mat2ndDev_setvar_GS2rep,limits={0,inf,1},value= root:SecondDeriv:Mat2dv_repetitionnum2
	SetVariable Mat2ndDev_setvar_GS4num,pos={53.00,56.00},size={44.00,13.00},proc=Mat2ndDev_SetVar_ChangeSmthPara,title="p"
	SetVariable Mat2ndDev_setvar_GS4num,font="Helvetica"
	SetVariable Mat2ndDev_setvar_GS4num,limits={7,25,2},value= root:SecondDeriv:Mat2dv_pointnum4
	SetVariable Mat2ndDev_setvar_GS4rep,pos={98.00,55.00},size={56.00,13.00},proc=Mat2ndDev_SetVar_ChangeSmthPara,title="rep"
	SetVariable Mat2ndDev_setvar_GS4rep,font="Helvetica"
	SetVariable Mat2ndDev_setvar_GS4rep,limits={0,inf,1},value= root:SecondDeriv:Mat2dv_repetitionnum4
	SetVariable Mat2ndDev_setvar_Binnum,pos={53.00,73.00},size={44.00,13.00},proc=Mat2ndDev_SetVar_ChangeSmthPara,title="p"
	SetVariable Mat2ndDev_setvar_Binnum,font="Helvetica"
	SetVariable Mat2ndDev_setvar_Binnum,limits={1,inf,1},value= root:SecondDeriv:Mat2dv_pointnumb
	SetVariable Mat2ndDev_setvar_Binrep,pos={98.00,73.00},size={56.00,13.00},proc=Mat2ndDev_SetVar_ChangeSmthPara,title="rep"
	SetVariable Mat2ndDev_setvar_Binrep,font="Helvetica"
	SetVariable Mat2ndDev_setvar_Binrep,limits={0,inf,1},value= root:SecondDeriv:Mat2dv_repetitionnumb
	Button Mat2ndDev_button_TopW,pos={107.00,19.00},size={41.00,16.00},proc=Mat2ndDev_Button_TopWindow,title="TopW"
	Button Mat2ndDev_button_TopW,fSize=10
	Button Mat2ndDev_button_show,pos={3.00,105.00},size={34.00,20.00},proc=Mat2ndDev_Button_ShowTrymat,title="Show"
	Button Mat2ndDev_button_show,fSize=10
	
	CheckBox Mat2ndDev_check_combo,pos={38.00,88.00},size={15.00,16.00},proc=Mat2ndDev_CheckBox_Combo,title=""
	CheckBox Mat2ndDev_check_combo,font="Helvetica",fSize=8,value= 1
	SetVariable Mat2ndDev_setvar_combx,pos={57.00,89.00},size={44.00,13.00},proc=Mat2ndDev_SetVar_ComboNum,title="x"
	SetVariable Mat2ndDev_setvar_combx,font="Helvetica"
	SetVariable Mat2ndDev_setvar_combx,limits={1,inf,1},value= root:SecondDeriv:Mat2dv_comb_x
	SetVariable Mat2ndDev_setvar_comby,pos={103.00,89.00},size={44.00,13.00},proc=Mat2ndDev_SetVar_ComboNum,title="y"
	SetVariable Mat2ndDev_setvar_comby,font="Helvetica"
	SetVariable Mat2ndDev_setvar_comby,limits={1,inf,1},value= root:SecondDeriv:Mat2dv_comb_y
	
	SetVariable Mat2ndDev_setvar_scalemin,pos={71.00,104.00},size={43.00,13.00},proc=Mat2ndDev_SetVar_ChangeColorScale,title=" "
	SetVariable Mat2ndDev_setvar_scalemin,font="Geneva",fSize=8
	SetVariable Mat2ndDev_setvar_scalemin,limits={-inf,inf,5},value= root:SecondDeriv:Mat2dv_min
	SetVariable Mat2ndDev_setvar_scalemax,pos={115.00,105.00},size={39.00,13.00},proc=Mat2ndDev_SetVar_ChangeColorScale,title=" "
	SetVariable Mat2ndDev_setvar_scalemax,font="Geneva",fSize=8
	SetVariable Mat2ndDev_setvar_scalemax,limits={-inf,inf,5},value= root:SecondDeriv:Mat2dv_max
	
	Button Mat2ndDev_button_Save,pos={4.00,128.00},size={36.00,20.00},proc=Mat2ndDev_Button_SaveResult,title="Save"
	Button Mat2ndDev_button_Save,fSize=10

	TitleBox Mat2ndDev_title_modeName,variable= root:SecondDeriv:Mat2dv_modeName,anchor= LC,fixedSize=1
	Button Mat2ndDev_button_done,pos={5.00,156.00},size={35.00,16.00},proc=Mat2ndDev_Button_Done,title="done"
	Button Mat2ndDev_button_done,fSize=10,fColor=(65535,32768,32768)
	CheckBox Mat2ndDev_check_SDOff,pos={118.00,2.00},size={15.00,16.00},proc=Mat2ndDev_CheckBox_SDOff,title=""
	CheckBox Mat2ndDev_check_SDOff,font="Helvetica",fSize=8,value= 0
	Button Mat2ndDev_button_RevColor,pos={134.00,129.00},size={15.00,16.00},proc=Mat2ndDev_Button_ReverseColor,title="R"
	Button Mat2ndDev_button_RevColor,fSize=10
	PopupMenu Mat2ndDev_popup_ColorScale,pos={44.00,129.00},size={67.00,23.00},bodyWidth=67,proc=Mat2ndDev_PupUp_SelectColorScale
	PopupMenu Mat2ndDev_popup_ColorScale,mode=20,value= #"\"*COLORTABLEPOPNONAMES*\""

	Button Mat2ndDev_button_EKmap,pos={44.00,153.00},size={70.00,26.00},proc=Mat2ndDev_Button_EKmap,title="E-K map"
	Button Mat2ndDev_button_EKmap,labelBack=(65535,49157,16385)
EndMacro


Function Mat2ndDev_SetUP()

	DFREF dfr
	
	if (DataFolderRefStatus(dfr) ==0)
		NewDataFolder/O root:SecondDeriv
	endif
	
	DFREF dfr = root:SecondDeriv

	
	Variable/G dfr:Mat2dv_mode=0//2階微分を行う方向		0 : EDC	1 : MDC	(case od 3Dmat,  2 : MDC(perpendicular to slit)
	String/G dfr:Mat2dv_modeName="0:EDC"
	Variable/G dfr:Mat2dv_pointnum2=7// (2nd order) Number of points
	Variable/G dfr:Mat2dv_repetitionnum2=2 //(2nd order) Number of repetitions
	Variable/G dfr:Mat2dv_pointnum4=25 // (4th order) Number of points
	Variable/G dfr:Mat2dv_repetitionnum4=1//(4th order) Number of repetitions
	Variable/G dfr:Mat2dv_pointnumb=2 //(Binominal) Number of points
	Variable/G dfr:Mat2dv_repetitionnumb=1 //repetitionnumb (Binominal) Number of repetitions
	
	String/G dfr:Mat2dv_OriMN=""
	
	Variable/G dfr:Mat2dv_comb_flag = 0
	Variable/G dfr:Mat2dv_comb_x = 1
	Variable/G dfr:Mat2dv_comb_y = 1
	Variable/G dfr:Mat2dv_Norm_flag = 0
	Variable/G dfr:Mat2dv_Norm_sr = 0
	Variable/G dfr:Mat2dv_Norm_er = 100
	
	Variable/G dfr:Mat2dv_max=50
	Variable/G dfr:Mat2dv_min=-50
	String/G dfr:Mat2dv_colorscheme="green"	
	
	Variable/G dfr:Mat2dv_SDoff=0
	
	Make/N=(100,100)/D/O dfr:trymat2dev

End


Function Mat2ndDev_Update_Mat2ndDev()

	String windowlist = winlist("SecondDerivative*",";","")
	String winname1
	
	if (ItemsInList(windowlist)!=0)
	Do
		winname1 = StringFromList(0, windowlist, ";")
		Dowindow $winname1
		if (V_flag==1)
			Dowindow/K  $winname1
			print "Kill window of old macro",winname1
		endif
		windowlist = RemoveListItem(0, windowlist, ";")
	while (ItemsInList(windowlist)!=0)
	endif
	
	Execute "SecondDerivative()"
	print "Creat window of new macro"
	
	//Mat2ndDev_SetUP()
	
	DFREF dfr = root:SecondDeriv
	DFREF dfrori = root

	SetDataFolder root:
	
	String StringVariableList ="Mat2dv_modeName;Mat2dv_OriMN;Mat2dv_colorscheme;"
	String StringVariableName
	
	Do
		StringVariableName = StringFromList(0, StringVariableList, ";")
		SVAR  copy=dfr:$StringVariableName
		SVAR  ori=root:$StringVariableName

		if(SVAR_Exists(ori)==1)
			copy=ori
			//print StringVariableName,copy,ori
			killstrings root:$StringVariableName

		endif
		
		StringVariableList = RemoveListItem(0, StringVariableList, ";")
	while (ItemsInList(StringVariableList)!=0)


	String NumberVariableList ="Mat2dv_mode;Mat2dv_pointnum2;Mat2dv_repetitionnum2;"
	NumberVariableList+="Mat2dv_pointnum4;Mat2dv_repetitionnum4;Mat2dv_pointnumb;"
	NumberVariableList+="Mat2dv_repetitionnumb;Mat2dv_comb_flag;Mat2dv_comb_x;Mat2dv_comb_y;"
	NumberVariableList+="Mat2dv_Norm_flag;Mat2dv_Norm_sr;Mat2dv_Norm_er;Mat2dv_max;"
	NumberVariableList+="Mat2dv_min;Mat2dv_SDoff;"

	String NumberVariableName
	
	Do
		NumberVariableName = StringFromList(0, NumberVariableList, ";")
		NVAR  copyv=dfr:$NumberVariableName
		NVAR  oriv=root:$NumberVariableName

		if(NVAR_Exists(oriv)==1)
			//print NumberVariableName,copyv,oriv
			copyv=oriv
			killVariables root:$NumberVariableName
		endif
		
		NumberVariableList = RemoveListItem(0, NumberVariableList, ";")
	while (ItemsInList(NumberVariableList)!=0)
	
	
	
End



Function  Mat2ndDev_Mat2deriv()		//3Dmatrixを二階微分
	
	DFREF dfr = root:SecondDeriv
	NVAR mode = dfr:Mat2dv_mode  //2階微分を行う方向		0 : EDC	1 : MDC(parallel to slit)		(case od 3Dmat,  2 : MDC(perpendicular to slit)
	NVAR pn2 = dfr:Mat2dv_pointnum2 // (2nd order) Number of points
	NVAR rep2 = dfr:Mat2dv_repetitionnum2 //(2nd order) Number of repetitions
	NVAR pn4 = dfr:Mat2dv_pointnum4 // (4th order) Number of points
	NVAR rep4 = dfr:Mat2dv_repetitionnum4//(4th order) Number of repetitions
	NVAR pnb = dfr:Mat2dv_pointnumb //(Binominal) Number of points
	NVAR repb = dfr:Mat2dv_repetitionnumb //repetitionnumb (Binominal) Number of repetition
	NVAR flag_SDoff = dfr:Mat2dv_SDoff

	SVAR  OriMN = dfr:Mat2dv_OriMN   //	Prompt mat3D "Original 3D matrix name"
	
	wave trymat2dev = dfr:trymat2dev

	PauseUpdate; Silent 1		// building window...
	
	Duplicate/O $OriMN, trymat2dev
	
	Mat2dev_DataComb(trymat2dev)
	
	
	Variable i=0

	If(i<rep2)
		Do
			Smooth/E=0/DIM=(mode)/S=2 pn2, trymat2dev
			i+=1		
		while(i<rep2)
	endif

	i=0

	If(i<rep4)
		Do
			Smooth/E=0/DIM=(mode)/S=4 pn4, trymat2dev
			i+=1
		while(i<rep4)
	endif

	i=0
	If(i<repb)
		Do
			Smooth/E=0/DIM=(mode) pnb, trymat2dev
			i+=1	
		while(i<repb)
	endif


	if (flag_SDoff==0)
		Differentiate/DIM=(mode)  trymat2dev
		Differentiate/DIM=(mode)  trymat2dev
	endif

End







Function Mat2ndDev_SetVar_ChangeSmthPara(ctrlName,varNum,varStr,varName) : SetVariableControl
	String ctrlName
	Variable varNum
	String varStr
	String varName
	
	 Mat2ndDev_Mat2deriv()	
  	 Mat2ndDev_UpdateColorsclae()

End


/////  Pick Up the matrix name on the top window
Function Mat2ndDev_Button_TopWindow(ctrlName) : ButtonControl
	String ctrlName
	
	DFREF dfr = root:SecondDeriv
	SVAR OriMN = dfr:Mat2dv_OriMN
	String MNlist
	String TopMatName	
	
	MNlist = WaveList("*",";","DIMS:2,WIN:")
	TopMatName=stringfromlist(0,MNlist)	
	OriMN = TopMatName
	
	Mat2ndDev_Mat2deriv()	

End

/////  Display the result of 2rnd derivative 
Function Mat2ndDev_Button_ShowTrymat(ctrlName) : ButtonControl
	String ctrlName

	DFREF dfr = root:SecondDeriv
	Wave trymat2dev = dfr:trymat2dev

	Dowindow  Show2ndDrv
	if (V_flag==0)
		Display/N=Show2ndDrv
		AppendImage trymat2dev
		ModifyGraph swapXY=1
		ModifyImage trymat2dev ctab= {*,*,Green,1}
		Mat2ndDev_UpdateColorsclae()
	else
		Dowindow/F  Show2ndDrv		
	endif

End


////////////////////  ColorScaleの制御関数 ////////////////////////////
////   matrixの最小値を-100%、最大値を100%、最頻値を0%とする  /////
////   +側と-側のscaleはことなることに注意　                                           /////

Function Mat2ndDev_UpdateColorsclae()

	DFREF dfr = root:SecondDeriv
	Wave trymat2dev = dfr:trymat2dev
	
	NVAR scalemax = dfr:Mat2dv_max
	NVAR scalemin = dfr:Mat2dv_min
	Variable mmax,mmin
	Variable mmode, mlevel
	Variable SetMin, SetMax
	SVAR coloescheme = dfr:Mat2dv_colorscheme

	mmax = wavemax(trymat2dev)
	mmin = wavemin(trymat2dev)
	
	imagehistogram trymat2dev
	mlevel	 = wavemax(W_ImageHist)
	Findlevel/Q W_ImageHist,(mlevel*0.98)
	mmode = V_LevelX
	
//	print mmin, mmode, mmax
	
	if (scalemin<0)
		SetMin = mmode + (scalemin /100) * (mmode-mmin)
	else
		SetMin = mmode + (scalemin /100) * (mmax-mmode)
	endif
	
	if (scalemax>0)
		SetMax = mmode + (scalemax /100) * (mmax-mmode)
	else
		SetMax = mmode + (scalemax/100) * (mmode-mmin)
	endif
	
//	print SetMin,SetMax
	ModifyImage/W=Show2ndDrv trymat2dev ctab= {SetMin,SetMax,$coloescheme,0}
	
	
End


Function Mat2ndDev_SetVar_ChangeColorScale(ctrlName,varNum,varStr,varName) : SetVariableControl
	String ctrlName
	Variable varNum
	String varStr
	String varName
	
 	 Mat2ndDev_UpdateColorsclae()
 
End


Function Mat2ndDev_Button_SaveResult(ctrlName) : ButtonControl
	String ctrlName
	
	
	
 	 Execute "Mat2ndDev_DuplicateResults()"
 
End


Function Mat2ndDev_DuplicateResults()

DFREF dfr = root:SecondDeriv
SVAR  OriMN = dfr:Mat2dv_OriMN

	String matrixname = OriMN + "_"
	Prompt matrixname,"Matrix name to dupliuate"
	Doprompt "Save results",matrixname

	
	Variable Flag_display
	Prompt Flag_display, "Do you want to show the result in new window (yes=1,no=0)?",popup,"yes;no"
	Doprompt "Coloring of new matrix",Flag_display

	wave trymat2dev = dfr:trymat2dev
	duplicate/o  trymat2dev $matrixname
	
	NVAR scalemax = dfr:Mat2dv_max
	NVAR scalemin = dfr:Mat2dv_min
	
	if ( Flag_display ==1)
		Display
		AppendImage $matrixname
		ModifyGraph swapXY=1
		Mat2ndDev_UpdateColorWIN(scalemin, scalemax)
	endif
	
	
Endmacro


Function Mat2ndDev_UpdateColorWIN(SetminP, SetmaxP)
Variable SetmaxP, SetminP

	Variable mmax,mmin
	Variable mmode, mlevel
	Variable SetMin, SetMax
	
	//String MN
	String MNlist
	String TopMatName	
	//MNlist = WaveList("*",";","DIMS:2,WIN:")
	MNlist=ImageNameList("",";")
	
	TopMatName=stringfromlist(0,MNlist)	
	//MN = TopMatName
	wave mat2d = imageNameToWaveRef("",TopMatName)

	mmax = wavemax(mat2d)
	mmin = wavemin(mat2d)
	
	imagehistogram mat2d
	mlevel	 = wavemax(W_ImageHist)
	Findlevel/Q W_ImageHist,(mlevel*0.98)
	mmode = V_LevelX
	
	
//	print mmin, mmode, mmax

	if (SetminP<0)
		SetMin = mmode + (SetminP /100) * (mmode-mmin)
	else
		SetMin = mmode + (SetminP /100) * (mmax-mmode)
	endif
	
	if (SetMaxP>0)
		SetMax = mmode + (SetMaxP /100) * (mmax-mmode)
	else
		SetMax = mmode + (SetMaxP/100) * (mmode-mmin)
	endif
	
	//print SetMin,SetMax

	DFREF dfr = root:SecondDeriv
	SVAR colorscheme = dfr:Mat2dv_colorscheme
	//string winname1 = winname(0,1)
	string matname = NameOfWave(mat2d)

	ModifyImage $matname ctab={SetMin,SetMax,$colorscheme,0}
	
	
End

Function  Mat2ndDev_SetVar_EDCMDCmode(ctrlName,varNum,varStr,varName) : SetVariableControl
	String ctrlName
	Variable varNum
	String varStr
	String varName
	
	DFREF dfr = root:SecondDeriv
	SVAR mode=dfr:Mat2dv_modeName
	if(varNum==0)
		mode="0:EDC"
	elseif (varNum==1)
		mode="1:MDC"
	endif	
	
	 Mat2ndDev_Mat2deriv()	
  	 Mat2ndDev_UpdateColorsclae()

End




Function Mat2ndDev_Button_Done(ctrlName) : ButtonControl
	String ctrlName
	
	Dowindow/K  SecondDerivative
	
End


Function Mat2ndDev_CheckBox_SDOff(ctrlName,checked) : CheckBoxControl
	String ctrlName
	Variable checked
	
	DFREF dfr = root:SecondDeriv
	NVAR flagSDoff = dfr:Mat2dv_SDoff

	
	flagSDoff = checked

 	Mat2ndDev_Mat2deriv()	
  	Mat2ndDev_UpdateColorsclae()
End



Function Mat2ndDev_Button_ReverseColor(ctrlName) : ButtonControl
	String ctrlName
	
	DFREF dfr = root:SecondDeriv
	NVAR scalemax = dfr:Mat2dv_max
	NVAR scalemin = dfr:Mat2dv_min
	
	variable stockvalue
	stockvalue = scalemax
	scalemax = scalemin
	scalemin = stockvalue
	
	Mat2ndDev_UpdateColorsclae()

End



Function Mat2ndDev_PupUp_SelectColorScale(ctrlName,popNum,popStr) : PopupMenuControl
	String ctrlName
	Variable popNum
	String popStr	
	
	DFREF dfr = root:SecondDeriv

	SVAR colorscheme=dfr:Mat2dv_colorscheme
	colorscheme = popStr
	
	 Mat2ndDev_UpdateColorsclae()

End







Function Mat2dev_DataComb(destmat)
	wave destmat

	DFREF dfr = root:SecondDeriv

	SVAR  oriMN = dfr:Mat2dv_OriMN

	duplicate/o $oriMN dfr:combmat

	wave combmat = dfr:combmat

	NVAR flag_com = dfr:Mat2dv_comb_flag
	NVAR comx = dfr:Mat2dv_comb_x
	NVAR comy = dfr:Mat2dv_comb_y
//	Variable/G Mat2dv_Norm_flag
//	Variable/G Mat2dv_Norm_sr
//	Variable/G Mat2dv_Norm_er
	
	
	if (cmpstr(oriMN ,"")==0)
		return -1
	endif
	
	if(flag_com==1)
		if (comx>1 || comy>1)
			  Mat2dev_combMat(combmat, comx, comy)
		endif
	endif
		
	//if(Mat2dv_Norm_flag==1)
	//	if (Mat2dv_Norm_sr < Mat2dv_Norm_er )
	//		  Mat2dev_NormMat(combmat, Mat2dv_Norm_sr ,Mat2dv_Norm_er)
	//	endif
	//endif

	duplicate/o combmat destmat
	killwaves combmat

End



Function Mat2dev_combMat(matname, cx, cy)
wave matname
Variable cx, cy

	variable xsize, ysize
	xsize = dimsize(matname,0)
	ysize = dimsize(matname,1)
	variable cxsize, cysize
	cxsize = floor(xsize/cx) + (mod(xsize,cx)!=0)
	cysize = floor(ysize/cy) + (mod(ysize,cy)!=0)
	
	Make/N=(cxsize, ysize)/D/O  redxmat
	redxmat =0
	variable ii=0, jj=0
	Do
		jj=0
		Do
			if ((ii*cx+jj)< (xsize+1))
			redxmat[ii][] +=  matname[ii*cx+jj][q]
			else
			redxmat[ii][] +=  matname[xsize][q]
			endif		
		jj+=1
		while (jj<(cx))
	ii+=1
	while(ii<(cxsize))
	
	Make/N=(cxsize, cysize)/D/O  redxymat
	redxymat =0
	ii=0
	Do
		jj=0
		Do
			if ((ii*cy+jj)< (ysize+1))
			redxymat[][ii] +=  redxmat[p][ii*cy+jj]
			else
			redxymat[][ii] +=  redxmat[q][ysize]
			endif		
		jj+=1
		while (jj<(cy))
	ii+=1
	while(ii<(cysize))
	

	
	variable xoffset, yoffset
	xoffset = dimoffset(matname,0)
	yoffset = dimoffset(matname,1)
	variable xdelta, ydelta
	xdelta = dimdelta(matname,0)
	ydelta = dimdelta(matname,1)
	//variable xend= xoffset + xsize * xdelta
	//variable yend= yoffset + ysize * ydelta
	variable cxdelta = cx* xdelta
	variable cydelta = cy* ydelta

	SetScale/P x xoffset, cxdelta,"", redxymat
	SetScale/P y yoffset, cydelta,"", redxymat
	
	duplicate/o redxymat matname
	killwaves redxymat

End




Function Mat2dev_NormMat(matname, sr , er)
wave matname
Variable sr, er

	variable ydim=Dimsize(matname,1)
	variable xdim=Dimsize(matname,0)
	duplicate /o matname showmat_image
	Make/N=(ydim)/D/O normfactor
	
	if (xdim<er)
		er=xdim
	endif

	normfactor=0
	variable ii
	ii= sr
	Do
		normfactor[]+=matname[ii][p]
	ii+=1
	while(ii<er+1)
	
	normfactor+=10
	showmat_image[][]/=normfactor[q]

	wavestats/Q showmat_image
	showmat_image*=50000/v_max
	
 	matname=showmat_image
 	
end



Function Mat2ndDev_CheckBox_Combo(ctrlName,checked) : CheckBoxControl
	String ctrlName
	Variable checked
	
	DFREF dfr = root:SecondDeriv

	NVAR flag_comb = dfr:Mat2dv_comb_flag 
//	Variable/G Mat2dv_Norm_flag 

	flag_comb  = checked
	 	
 	 Mat2ndDev_Mat2deriv()
 	 Mat2ndDev_UpdateColorsclae()
  
End



Function Mat2ndDev_SetVar_ComboNum(ctrlName,varNum,varStr,varName) : SetVariableControl
	String ctrlName
	Variable varNum
	String varStr
	String varName

	 Mat2ndDev_Mat2deriv()	
  	 Mat2ndDev_UpdateColorsclae()

End



Function Mat2ndDev_Button_EKmap(ctrlName) : ButtonControl
	String ctrlName
	
	Dowindow  EKmap
	if (V_flag==0)
			Execute "EKmap()" 
	endif
	Dowindow/F  EKmap
End




/////////////////////////////////////////////////////////////////
////////////////    Wave Conversion Procedure  /////////////////
/////////////////////////////////////////////////////////////////

Window EKmap() : Panel
	//PauseUpdate; Silent 1		// building window...
	Mat2ndDev_SetupWaveConversion()
	NewPanel /W=(633,254,792,351)
	ModifyPanel cbRGB=(65535,49151,49151)
	SetDrawLayer UserBack
	SetDrawEnv fillfgc= (32768,40777,65535)
	SetDrawEnv save
	SetVariable Mat2ndDev_setvar_center,pos={9.00,6.00},size={60.00,13.00},proc=Mat2ndDev_SetVar_center,title="cen"
	SetVariable Mat2ndDev_setvar_center,font="Helvetica"
	SetVariable Mat2ndDev_setvar_center,limits={1,inf,1},value= root:SecondDeriv:mat2dv_WC_CenterA
	SetVariable Mat2ndDev_setvar_AngW,pos={69.00,6.00},size={68.00,13.00},title="width"
	SetVariable Mat2ndDev_setvar_AngW,font="Helvetica"
	SetVariable Mat2ndDev_setvar_AngW,limits={1,inf,1},value= root:SecondDeriv:mat2dv_WC_AngW
	CheckBox Mat2ndDev_check_KEBE,pos={12.00,24.00},size={15.00,16.00},proc=Mat2ndDev_WC_CheckBox_KEBE,title=""
	CheckBox Mat2ndDev_check_KEBE,font="Helvetica",fSize=8
	CheckBox Mat2ndDev_check_KEBE,variable= mat2dv_WC_KEBE_flag
	SetVariable Mat2ndDev_setvar_EF,pos={39.00,25.00},size={80.00,13.00},title="EF"
	SetVariable Mat2ndDev_setvar_EF,font="Helvetica"
	SetVariable Mat2ndDev_setvar_EF,limits={1,inf,1},value= root:SecondDeriv:mat2dv_WC_EF
	SetVariable Mat2ndDev_setvar_Emesh,pos={11.00,45.00},size={80.00,13.00},disable=2,title="Emesh"
	SetVariable Mat2ndDev_setvar_Emesh,font="Helvetica"
	SetVariable Mat2ndDev_setvar_Emesh,limits={1,inf,1},value= root:SecondDeriv:mat2dv_WC_Emesh
	SetVariable Mat2ndDev_setvar_Kmesh,pos={12.00,60.00},size={79.00,13.00},title="kmesh"
	SetVariable Mat2ndDev_setvar_Kmesh,font="Helvetica"
	SetVariable Mat2ndDev_setvar_Kmesh,limits={1,inf,1},value= root:SecondDeriv:mat2dv_WC_kmesh
	Button Mat2ndDev_Button_EKmap,pos={95.00,38.00},size={45.00,20.00},proc=Mat2ndDev_WC_Button_AngToK,title="K-Emap"
	Button Mat2ndDev_Button_EKmap,fSize=10
	Button Mat2ndDev_button_done,pos={99.00,60.00},size={35.00,16.00},proc=Mat2ndDev_WC_done,title="done"
	Button Mat2ndDev_button_done,fSize=10,fColor=(65535,32768,32768)
EndMacro




Function Mat2ndDev_SetupWaveConversion()

	if (DataFolderExists("root:SecondDeriv")==0)
		return -1
	else
		DFREF dfr = root:SecondDeriv
	endif

	Variable/G dfr:mat2dv_WC_KEBE_flag = 0
	Variable/G dfr:mat2dv_WC_EF = 16.87
	Variable/G dfr:mat2dv_WC_CenterA
	Variable/G dfr:mat2dv_WC_AngW = 14
	Variable/G dfr:mat2dv_WC_Emesh = 100
	Variable/G dfr:mat2dv_WC_kmesh = 100

	wave trymat2dev = dfr:trymat2dev

		if(WaveExists(trymat2dev)==0)
			return -1
		endif
		
		Dowindow  Show2ndDrv
		if (V_flag==0)
			return -1
		elseif (V_flag==1)
			Dowindow/F  Show2ndDrv
		endif
		
	wave trymat2dev = dfr:trymat2dev
	
	variable Mangx_start
	variable Mangx_end
	variable Mangx_step
	variable ME_start
	variable ME_end
	
	Mangx_start = dimoffset (trymat2dev,1)
	Mangx_end = dimoffset (trymat2dev,1) + (dimsize(trymat2dev,1)-1) * dimdelta(trymat2dev,1)
	Mangx_step = dimdelta(trymat2dev,1)
	ME_start = dimoffset (trymat2dev,0)
	ME_end = dimoffset (trymat2dev,0) + (dimsize(trymat2dev,0)-1) * dimdelta(trymat2dev,0)

	print 	Mangx_start ,Mangx_end ,Mangx_step
	print  ME_start,ME_end
	make/o/n=2  dfr:Mat2dev_WC_lineE,dfr:Mat2dev_WC_linek
	Wave lineE = dfr:Mat2dev_WC_lineE
	Wave lineK = dfr:Mat2dev_WC_linek
	NVAR center = dfr:mat2dv_WC_CenterA
	print center
	lineE[0] = ME_start
	lineE[1] = ME_end
	center =(floor(dimsize(trymat2dev,1)/2)-1)
	lineK =Mangx_start + center  * dimdelta(trymat2dev,1)
	
	
	if ( whichlistitem ("Mat2dev_WC_lineE",tracenamelist("Show2ndDrv",";",1),";",0,1) ==-1)
		AppendtoGraph/W=Show2ndDrv lineK vs lineE
	endif
		
End





Function Mat2ndDev_SetVar_center(ctrlName,varNum,varStr,varName) : SetVariableControl
	String ctrlName
	Variable varNum
	String varStr
	String varName

	DFREF dfr = root:SecondDeriv

	if (waveexists(dfr:Mat2dev_WC_linek)==0)
	 return -1
	endif
	if (waveexists(dfr:trymat2dev)==0)
	 return -1
	endif
	
	wave linek = dfr:Mat2dev_WC_linek
	wave trymat2dev = dfr:trymat2dev
	
	linek =dimoffset (trymat2dev,1)+  varNum* dimdelta(trymat2dev,1)
	
End


Function Mat2ndDev_WC_CheckBox_KEBE(ctrlName,checked) : CheckBoxControl
	String ctrlName
	Variable checked
	
	DFREF dfr = root:SecondDeriv

	NVAR flag_KRBR = dfr:mat2dv_WC_KEBE_flag
	NVAR  EF = dfr:mat2dv_WC_EF


	
	if (waveexists(dfr:trymat2dev)==0)
	 return -1
	endif
	wave trymat2dev = dfr:trymat2dev
	
	SVAR OriMN = dfr:Mat2dv_OriMN
	if (waveexists($OriMN)==0)
	 return -1
	endif
	
	variable Estart, Estep
	Estart = Dimoffset($OriMN,0)
	Estep = Dimdelta(trymat2dev,0)


	
	if (checked ==1)
		SetScale/P x (Estart+EF),Estep,"", trymat2dev
	elseif (checked ==0)
		SetScale/P x (Estart),Estep,"", trymat2dev
	endif
	
	wave lineE = dfr:Mat2dev_WC_lineE
	lineE[0] = dimoffset(trymat2dev,0)
	lineE[1] = dimoffset(trymat2dev,0) + dimdelta(trymat2dev,0)*dimsize(trymat2dev,0)
  
End



Function Mat2ndDev_WC_Button_AngToK(ctrlName) : ButtonControl
String ctrlName

	Mat2ndDev_WC_Bandmap_Normal()
	
	DFREF dfr = root:SecondDeriv

	NVAR cmin = dfr:Mat2dv_min
	NVAR cmax = dfr:Mat2dv_max
	
	wave bandmapM1=dfr:bandmapM1
	string winname1
	
	Display
	AppendImage bandmapM1
	winname1 = winname(0,1)
	//matrixtranspose bandmapM1   this is necessary for ushi_fast
	ModifyGraph/W=$winname1 swapXY=1
	Mat2ndDev_UpdateColorWIN(cmin, cmax)
	
End


Function Mat2ndDev_WC_done(ctrlName) : ButtonControl
String ctrlName

	Dowindow  Show2ndDrv
	if (V_flag==0)
	 return -1
	endif
	

	if ( whichlistitem ("Mat2dev_WC_linek",tracenamelist("Show2ndDrv",";",1),";",0,1) !=-1)
		RemovefromGraph/W=Show2ndDrv  Mat2dev_WC_linek 
	endif

	Dowindow  EKmap
	if (V_flag==1)
		Dowindow/K  EKmap
	endif
	
End







Function Mat2ndDev_WC_Bandmap_UshiFast()
wave trymat2dev			// original matrix (E vs deg)
wave Mat2dev_WC_linek 	//  angle of normal


	if (waveexists(Mat2dev_WC_linek)==0)
	 return -1
	endif
	if (waveexists(trymat2dev)==0)
	 return -1
	endif
	
	Variable/G mat2dv_WC_KEBE_flag   
	Variable/G mat2dv_WC_EF 
	Variable/G mat2dv_WC_CenterA   // Actually, this variable given as point of center
	Variable/G mat2dv_WC_AngW 
	Variable/G mat2dv_WC_Emesh
	Variable/G mat2dv_WC_kmesh
	
	//tic()
	/////////////////  matrix transpose  ///////////////////////
	
	// legacy code suppose matrix (E vs ang(or k))
	// bandmapM0: angle is corrected from trymat2dev
		
	duplicate/o trymat2dev  bandmapM0
	matrixtranspose bandmapM0  // x-deg, y-E

	
	////////////  Angle resclae of bandmap0   //////////////////////
	Variable NewDelta, Anglemag
	NewDelta = mat2dv_WC_AngW/(dimsize(bandmapM0,0))
	Anglemag = NewDelta/dimdelta(bandmapM0,0)
	
	// normal angle set to 0, and angle is scaled 
	setscale/P x  (Anglemag*(dimoffset(bandmapM0,0)-Mat2dev_WC_linek[0])),NewDelta,bandmapM0
	
	
	////////////////////  bandmapping procedure  //////////////////////////
	// bandmap M1 is destination of k-ang conversion
	Make/N=(mat2dv_WC_Emesh,mat2dv_WC_kmesh)/D/O bandmapM1

	variable KEmin, KEmax, KENum,KEDelta, Tmin, Tmax, TNum, BEmin, BEmax, WVmin, WVmax, TDelta
	KEmin=Dimoffset(bandmapM0,1)
	KENum=Dimsize(bandmapM0,1)
	KEDelta=Dimdelta(bandmapM0,1)
	KEmax=KEmin+KEDelta*(KENum-1)
	Tmin=Dimoffset(bandmapM0,0)
	TDelta=Dimdelta(bandmapM0,0)
	TNum=Dimsize(bandmapM0,0)
	Tmax=Tmin+TDelta*(TNum-1)
	BEmin=KEmin-mat2dv_WC_EF 
	BEmax=KEmax-mat2dv_WC_EF 
	WVmin=sqrt(KEmax/3.81283)*sin((Tmin)*pi/180)		//Wave vector min を計算
	WVmax=sqrt(KEmax/3.81283)*sin((Tmax)*pi/180)		//Wave vector max を計算

	
	SetScale/I x WVmin,WVmax,"", bandmapM1	; Delayupdate		//rescale of bandmapM1
	SetScale/I y BEmin,BEmax,"", bandmapM1							//rescale of bandmapM1
	String MatBEWave="MBW"
	Duplicate/O bandmapM0 $MatBEWave									//$MatBEWave: BE representaion of bandmapM0
	SetScale/I y BEmin,BEmax,"", $MatBEWave						

	Make/N=(TNum,2)/D/O mat2line
	Make/N=(TNum*4,3)/D/O mat3line
	Make/N=(mat2dv_WC_kmesh,2)/D/O matline
	
	Variable i=0,KE,BE
	Variable Ext1,Ext2,j,WV2min,WV2max,BE2min,BE2max,Uptime,pers=1,BEave,BEdelta
	Variable sumM
	Pauseupdate; silent 1
	bandmapM1=0



	Display

// K-ang conversion at each E-slice of M1
// silec delta is from E-mesh

	Do
		BE=Dimoffset(bandmapM1,1)+Dimdelta(bandmapM1,1)*i // BE in M1 at i point
		KE=BE+mat2dv_WC_EF					// KE in M1 at i point
		Ext1=floor((KE-KEmin)/KEDelta) // y point of M0 corresponding to KE(i) in M1
		Ext2=Ext1+1								// next y point of M0 
	
		BE2min=KEDelta*Ext1+KEmin-mat2dv_WC_EF // BE of M0 @ KE(i) in M1
		BE2max=KEDelta*Ext2+KEmin-mat2dv_WC_EF // next BE of M0 
		BEave=(BE2min+BE2max)/2 // average BE in M0
		BEdelta=BE2max-BE2min  //  same as KEdelta in M0
		
		WV2min=Mat2ndDev_WC_ThWv(KE,Tmin)		//WV min at energy of KE(i) in M1
		WV2max=Mat2ndDev_WC_ThWv(KE,Tmax)		//WV max at energy of KE(i) in M1
		
		SetScale/I x WV2min,WV2max,"", mat2line	; Delayupdate		
     	SetScale/I y ,BE2min, BE2max,"", mat2line				

		Mat2ndDev_WC_AngKpara(bandmapM0,mat3line,KE,Tmin,Tdelta,TNum,Ext1,Ext2,BE2min,BE2max,BEdelta,mat2dv_WC_EF)
		
		//mat3line[0-(Tnum-1)][0]  WV @ (tht_m0,BE-delta_m0) 
		//mat3line[0-(Tnum-1)][1]  BE-delta_m0
		//mat3line[0-(Tnum-1)][2]  M0 intensity @ (tht_m0,BE-delta_m0) 
		//mat3line[Tnum-(2*Tnum-1)][i] those above for BE_m0
		//mat3line[2*Tnum-(3*Tnum-1)][i] those above for BE+delta_m0
		//mat3line[3*Tnum-(4*Tnum-1)][i] those above for BE+2*delta_m0

		SetScale/I x WVmin,WVmax,"", matline	; Delayupdate		
		SetScale/I y BE2min,BE2max,"",  matline
		AppendXYZContour mat3line
		
		mat2line=ContourZ("","",0,x,y)
		sumM = sum(mat2line)
		if (sumM==0)
			print "out of memory in AppendXYZContour"
			return -1
		endif
			
		RemoveContour mat3line		//Contourグラフを削除
	
		mat2line[0][0]=mat2line[0][1]
		mat2line[Tnum-1][0]=mat2line[Tnum-1][1]
		
		AppendMatrixContour mat2line
		matline=ContourZ("","",0,x,y)
		RemoveContour mat2line		//Contourグラフを削除
		Mat2ndDev_WC_oneline(matline,bandmapM1,i,mat2dv_WC_kmesh)
		
		if ((mod((i-1),(mat2dv_WC_Emesh/10))-mod(i,(mat2dv_WC_Emesh/10)))!=-1)
	 		print floor(i/mat2dv_WC_Emesh*10)*10,"% done"
		endif
	
		

		i+=1	
	While (i<=mat2dv_WC_Emesh)
	
	DoWindow/K $WinName(0,1)		//Contourグラフを削除

	//toc()
	
end





function Mat2ndDev_WC_ThWv(KE,theta)
variable KE,theta
return (sqrt(KE/3.81283)*sin((theta)*pi/180))
End

function Mat2ndDev_WC_oneline(ori,dest,ext,total)
Wave ori,dest
variable ext, total
variable j
j=0
Do
dest[j][Ext]=ori[j][0]
j+=1
While (j<=total)
End



function Mat2ndDev_WC_AngKpara(M0,mat3line,KE,Tmin,Tdelta,TNum,Ext1,Ext2,BE2min,BE2max,BEdelta,EF)
Wave M0,mat3line
Variable KE,Tmin,Tdelta,TNum,Ext1,Ext2,BE2min,BE2max,BEdelta,EF
variable ite,tht

		// ori [ang][E]
		// dest [ang*4][3]
		// KE: KE(i) of M1, Tmin: thetamin of M0, Tdelta: thetadelta of M0, Tnum: Tsize of M0
		// EXt1: y point of bandmapM0 corresponding to KE in bandmapM1
		// BE2min: BE of M0 @ KE(i) in M1, BE2max: next BE of M0 
		// BEdelta: same as KEdelta in M0
		
	Do  //M0のthetaのサイズだけ繰り返し
	
	tht=Tmin+ite*Tdelta
	
	// 
	mat3line[ite][0]=sqrt((BE2min-BEdelta+EF)/3.81283)*sin((Tht)*pi/180) // WV at (tht,BE-delta) 
	mat3line[ite][1]=BE2min-BEdelta // BE-delta
	mat3line[ite][2]=M0[ite][Ext1-1] // M0 intensity @ (tht,BE-delta)  
	//
	mat3line[ite+Tnum][0]=sqrt((BE2min+EF)/3.81283)*sin((Tht)*pi/180) // WV at (tht,BE) 
	mat3line[ite+Tnum][1]=BE2min // BE
	mat3line[ite+Tnum][2]=M0[ite][Ext1]// M0 intensity @ (tht,BE)  
	//
	mat3line[ite+2*Tnum][0]=sqrt((BE2max+EF)/3.81283)*sin((Tht)*pi/180)// WV at (tht,BE+delta) 
	mat3line[ite+2*Tnum][1]=BE2max // BE+delta
	mat3line[ite+2*Tnum][2]=M0[ite][Ext1+1] // M0 intensity @ (tht,BE+delta) 
	//
	mat3line[ite+3*Tnum][0]=sqrt((BE2max+BEdelta+EF)/3.81283)*sin((Tht)*pi/180) // WV at (tht,BE+2*delta)
	mat3line[ite+3*Tnum][1]=BE2max+BEdelta// BE+2*delta
	mat3line[ite+3*Tnum][2]=M0[ite][Ext1+2]// M0 intensity @ (tht,BE+2*delta) 
	
	ite+=1
	While (ite<TNum)

End




Function Mat2ndDev_WC_Bandmap_Normal ()

	DFREF dfr = root:SecondDeriv

	wave trymat2dev = dfr:trymat2dev		// original matrix (E vs deg)
	wave linek = dfr:Mat2dev_WC_linek 	//  angle of normal

//tic()

	if (waveexists(linek)==0)
	 return -1
	endif
	if (waveexists(trymat2dev)==0)
	 return -1
	endif
	
	NVAR flag_KEBE = dfr:mat2dv_WC_KEBE_flag   
	NVAR EF = dfr:mat2dv_WC_EF 
	NVAR centerA = dfr:mat2dv_WC_CenterA   // Note; this variable gives center point in unit of point
	NVAR anglewidth = dfr:mat2dv_WC_AngW 
//	NVAR Emseh = dfr:mat2dv_WC_Emesh
	NVAR Kmesh = dfr:mat2dv_WC_kmesh
	
		
	// legacy code suppose matrix (E vs ang(or k))
	// bandmapM0: angle is corrected from trymat2dev
		
	duplicate/o trymat2dev  dfr:bandmapM0
	wave bandmapM0 = dfr:bandmapM0
	VAriable M0sizeE = dimsize(bandmapM0,0)
	VAriable M0sizeA = dimsize(bandmapM0,1)

	
	////////////  Angle resclae of bandmap0   //////////////////////
	Variable NewDelta, Anglemag
	NewDelta = anglewidth/(dimsize(bandmapM0,1))
	Anglemag = NewDelta/dimdelta(bandmapM0,1)
	
	// normal angle set to 0, and angle is scaled 
	setscale/P y  (-centerA*NewDelta),NewDelta,bandmapM0
	

	
	////////////////////  bandmapping procedure  //////////////////////////
	// bandmapM0: source data (0:Kinetic Energy, 1:angle)
	// bandmapM1: destination data (0:Binding Energy, 1:wave vector)
	
	// Emseh is same as bandmapM0
	Make/N=(M0sizeE,Kmesh)/D/O dfr:bandmapM1
	wave bandmapM1 = dfr:bandmapM1
	
	variable KEmin,KEmax,Tmin,Tmax,WVmin,WVmax
	
	KEmin = Dimoffset(bandmapM0,0)
	KEmax = Dimoffset(bandmapM0,0)+Dimdelta(bandmapM0,0)*(Dimsize(bandmapM0,0)-1)
	Tmin = Dimoffset(bandmapM0,1)
	Tmax = Dimoffset(bandmapM0,1)+Dimdelta(bandmapM0,1)*(Dimsize(bandmapM0,1)-1)

	// Calculatio of wave vector from kinetic energy and angle
	duplicate/o bandmapM0 dfr:WaveVectorM0 
	wave  WaveVectorM0=dfr:WaveVectorM0
	WaveVectorM0 = 0.512*sqrt(x)*sin(y/180*pi)

	//rescale of bandmapM1
	WVmin=WaveVectorM0[M0sizeE-1][0]  //wave vector range is given at largest kinetic energy
	WVmax=WaveVectorM0[M0sizeE-1][M0sizeA-1]
	SetScale/I y WVmin,WVmax,"", bandmapM1	; Delayupdate		//rescale of bandmapM1
	SetScale/I x (KEmin-EF),(KEmax-EF ),"", bandmapM1	// binding energy
	
	//reasampling bandmapM0
	make/D/N=(Kmesh)/o ipwave1d,ipwave1x  //interporation waves
	make/D/N=(Dimsize(bandmapM0,1))/o srcwave1d,srcwave1x //source waves  1d:value of M0, 1x:wave vector
	
	SetScale/P x WVmin,(DimDelta(bandmapM1,1)),"", ipwave1x
	ipwave1x = x
	
	variable eline=0
	variable ws,we
	
	Do
		// iregular x-step of source1d vs 1x is interprated to 
		// regular step data of ipwave1d vs 1x 
		srcwave1d = bandmapM0[eline][p]
		srcwave1x = WaveVectorM0[eline][p]
		Interpolate2/T=2/E=2/Y=ipwave1d/X=ipwave1x/I=3 srcwave1x,srcwave1d
		bandmapM1[eline][] = ipwave1d[q]
		
		// cut 
		ws = WaveVectorM0[eline][0]
		we = WaveVectorM0[eline][M0sizeA]
		bandmapM1[eline][0,x2pnt(ipwave1x,ws)] = nan
		bandmapM1[eline][x2pnt(ipwave1x,we),] = nan

		eline=eline +1
	while(eline<(M0sizeE))
	
	killwaves ipwave1d,ipwave1x,srcwave1d,srcwave1x
		
	//toc()
end



/////////////			コマンドラインからの命令用 		//////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////
macro DMat_2deriv(mode,newname,pointnum2,repetitionnum2,pointnum4,repetitionnum4,pointnumb,repetitionnumb)		//3Dmatrixを二階微分
variable mode=0		//2階微分を行う方向		0 : EDC方向	1 : MDC方向
Prompt mode "Mode:Raw=0;Column=1"
string newname="showM22ndDev"
Prompt newname "New 3Dmat name (ex. 20, 21, 22)"
variable pointnum2=7
Prompt pointnum2 "(2nd order) Number of points"
variable repetitionnum2=2
Prompt repetitionnum2 "(2nd order) Number of repetitions"
variable pointnum4=25
Prompt pointnum4 "(4th order) Number of points"
variable repetitionnum4=1
Prompt repetitionnum4 "(4th order) Number of repetitions"
variable pointnumb=25
Prompt pointnumb "(Binominal) Number of points"
variable repetitionnumb=1
Prompt repetitionnumb "(Binominal) Number of repetitions"


	string mat3D="ShowM2"
//	Prompt mat3D "Original 3D matrix name"

	PauseUpdate; Silent 1		// building window...

	Duplicate/O $mat3d,$newname

variable i=0

If(i<repetitionnum2)

	Do

		Smooth/E=0/DIM=(mode)/S=2 pointnum2, $newname
		i+=1
		
	while(i<repetitionnum2)

endif

i=0

If(i<repetitionnum4)

	Do

		Smooth/E=0/DIM=(mode)/S=4 pointnum4, $newname
		i+=1
		
	while(i<repetitionnum4)

endif

i=0

If(i<repetitionnumb)

	Do

		Smooth/E=0/DIM=(mode) pointnumb, $newname
		i+=1
		
	while(i<repetitionnumb)

endif

Differentiate/DIM=(mode)  $newname
Differentiate/DIM=(mode)  $newname

end



