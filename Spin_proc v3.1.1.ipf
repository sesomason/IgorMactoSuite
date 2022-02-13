#pragma TextEncoding = "Shift_JIS"
#pragma rtGlobals=1		// Use modern global access method.



//  Script to load MBS-A1 and Scienta-omicrion data
//  written in Igor 8.04 (64 bit)
//  
//  Seigo Soiuma,    Tohoku University  
//
//  ver 3.1.0  Adapted to krx format of spin data taken by A1 software  (Sep 26, 2020)
//					if one needs to analyse old type data (***.mot), use older vresion than 3.0.0
//


	
Window SpinPanel() : Panel
	PauseUpdate; Silent 1		// building window...
	
	Spin_SetUPSpinPAnel()
	
	NewPanel /W=(772,57,1150,329)
	ModifyPanel cbRGB=(65535,0,0)
	SetDrawLayer UserBack
	SetDrawEnv linethick= 0,fillfgc= (65535,60076,49151)
	DrawRect 7,27,138,269
	SetDrawEnv linethick= 0,fillfgc= (65535,65534,49151)
	DrawRect 141,26,375,188
	SetDrawEnv fname= "Times",fsize= 16,fstyle= 1
	DrawText 148,45,"Display results control"
	SetDrawEnv fname= "Times",fstyle= 1
	DrawText 147,103,"Asm"
	SetDrawEnv fname= "Times",fstyle= 1
	DrawText 257,101,"y"
	SetDrawEnv fname= "Times",fstyle= 1
	DrawText 175,101,"z"
	SetDrawEnv fname= "Times",fstyle= 1
	DrawText 148,120,"Pol"
	SetDrawEnv fname= "Times",fstyle= 1
	DrawText 257,101,"y"
	SetDrawEnv fname= "Times",fstyle= 1
	DrawText 175,101,"z"
	SetDrawEnv fname= "Times",fstyle= 1
	DrawText 257,119,"y"
	SetDrawEnv fname= "Times",fstyle= 1
	DrawText 175,119,"z"
	SetDrawEnv fname= "Times",fstyle= 1
	DrawText 148,147,"Spin"
	SetDrawEnv fname= "Times",fstyle= 1
	DrawText 161,183,"z"
	SetDrawEnv fname= "Times",fstyle= 1
	DrawText 173,183,"up"
	SetDrawEnv fname= "Times",fstyle= 1
	DrawText 212,183,"z"
	SetDrawEnv fname= "Times",fstyle= 1
	DrawText 224,183,"down"
	SetDrawEnv fname= "Times",fstyle= 1
	DrawText 277,185,"y"
	SetDrawEnv fname= "Times",fstyle= 1
	DrawText 289,185,"up"
	SetDrawEnv fname= "Times",fstyle= 1
	DrawText 328,185,"y"
	SetDrawEnv fname= "Times",fstyle= 1
	DrawText 340,185,"down"
	SetDrawEnv fname= "Times",fsize= 16,fstyle= 1
	DrawText 18,43,"analysis control"
	DrawText 14,65,"global"
	DrawLine 21,124,124,124
	DrawText 20,148,"parameter set"
	SetDrawEnv fname= "Times",fsize= 16,fstyle= 1
	DrawText 257,80,"norm"
	SetDrawEnv fname= "Times",fsize= 16,fstyle= 1
	DrawText 166,80,"raw"
	SetDrawEnv fname= "Times"
	DrawText 346,18,"v3.0.0"
	SetDrawEnv fname= "Geneva",fsize= 10
	DrawText 179,246,"UPdataAll"
	TitleBox Spin_WNameAsm_z_title,pos={183.00,88.00},size={38.00,18.00}
	TitleBox Spin_WNameAsm_z_title,labelBack=(65535,65535,65535),font="Times"
	TitleBox Spin_WNameAsm_z_title,frame=2,variable= root:SpinAnalysis:SG_AsyWNz
	TitleBox Spin_WNameAsm_y_title,pos={265.00,88.00},size={39.00,18.00}
	TitleBox Spin_WNameAsm_y_title,labelBack=(65535,65535,65535),font="Times"
	TitleBox Spin_WNameAsm_y_title,frame=2,variable= root:SpinAnalysis:SG_AsyWNy
	TitleBox Spin_WNamePol_z_title,pos={183.00,106.00},size={39.00,18.00}
	TitleBox Spin_WNamePol_z_title,labelBack=(65535,65535,65535),font="Times"
	TitleBox Spin_WNamePol_z_title,frame=2,variable= root:SpinAnalysis:SG_PolWNz
	TitleBox Spin_WNamePol_y_title,pos={265.00,106.00},size={39.00,18.00}
	TitleBox Spin_WNamePol_y_title,labelBack=(65535,65535,65535),font="Times"
	TitleBox Spin_WNamePol_y_title,frame=2,variable= root:SpinAnalysis:SG_PolWNy
	TitleBox Spin_WName_zup_title,pos={149.00,155.00},size={41.00,16.00}
	TitleBox Spin_WName_zup_title,labelBack=(65535,65535,65535),font="Times",fSize=8
	TitleBox Spin_WName_zup_title,frame=2,variable= root:SpinAnalysis:SG_UpWNz
	TitleBox Spin_WName_zdn_title,pos={207.00,155.00},size={41.00,16.00}
	TitleBox Spin_WName_zdn_title,labelBack=(65535,65535,65535),font="Times",fSize=8
	TitleBox Spin_WName_zdn_title,frame=2,variable= root:SpinAnalysis:SG_DnWNz
	TitleBox Spin_WName_yup_title,pos={266.00,155.00},size={41.00,16.00}
	TitleBox Spin_WName_yup_title,labelBack=(65535,65535,65535),font="Times",fSize=8
	TitleBox Spin_WName_yup_title,frame=2,variable= root:SpinAnalysis:SG_UpWNy
	TitleBox Spin_WName_ydn_title,pos={324.00,155.00},size={41.00,16.00}
	TitleBox Spin_WName_ydn_title,labelBack=(65535,65535,65535),font="Times",fSize=8
	TitleBox Spin_WName_ydn_title,frame=2,variable= root:SpinAnalysis:SG_DnWNz
	Button Spin_ShowAssyData_button,pos={326.00,88.00},size={42.00,16.00},proc=Spin_button_ShowAssyData,title="Show"
	Button Spin_ShowAssyData_button,fSize=10
	Button Spin_ShowPolData_button,pos={326.00,106.00},size={42.00,16.00},proc=Spin_button_ShowPolData,title="Show"
	Button Spin_ShowPolData_button,fSize=10
	Button Spin_ShowSpinARPES_button,pos={179.00,134.00},size={42.00,16.00},proc=Spin_button_ShowSpinARPES,title="Show"
	Button Spin_ShowSpinARPES_button,fSize=10
	Button Spin_ShowNrmData_button,pos={299.00,65.00},size={42.00,16.00},proc=Spin_button_ShowNormSpectra,title="Show"
	Button Spin_ShowNrmData_button,fSize=10
	SetVariable Spin_Shermann_setvar,pos={58.00,50.00},size={74.00,17.00},proc=Spin_setvar_ParameterUpdate,title="\\Z09Shrm"
	SetVariable Spin_Shermann_setvar,font="Times",fSize=13
	SetVariable Spin_Shermann_setvar,limits={0,1,0.01},value= root:SpinAnalysis:VG_Seff
	SetVariable Spin_setdataN_setvar,pos={17.00,7.00},size={50.00,14.00},proc=Spin_setvar_setdataNum,title=" "
	SetVariable Spin_setdataN_setvar,value= root:SpinAnalysis:VG_MN_Mottmatrix
	SetVariable Spin_matname_setvar,pos={68.00,6.00},size={92.00,14.00},proc=Spin_setvar_SetMatName,title=" "
	SetVariable Spin_matname_setvar,value= root:SpinAnalysis:MN_Mottmatrix
	PopupMenu Spin_Epass_popup,pos={283.00,4.00},size={59.00,23.00},proc=Spin_popup_SelectEpass
	PopupMenu Spin_Epass_popup,mode=4,popvalue="Ep10",value= #"\"Ep1;Ep2;Ep5;Ep10\""
	SetVariable Spin_InstAss_z_setvar,pos={24.00,69.00},size={107.00,14.00},proc=Spin_setvar_ParameterUpdate,title=" instAs:z"
	SetVariable Spin_InstAss_z_setvar,limits={0.3,3,0.001},value= root:SpinAnalysis:VG_InstAssy_z
	SetVariable Spin_InstAss_y_setvar,pos={24.00,88.00},size={108.00,14.00},proc=Spin_setvar_ParameterUpdate,title=" instAs:y"
	SetVariable Spin_InstAss_y_setvar,limits={0.3,3,0.001},value= root:SpinAnalysis:VG_InstAssy_y
	PopupMenu Spin_SelectDisplayType_popup,pos={149.00,45.00},size={105.00,23.00},proc=PopMenuProc_4
	PopupMenu Spin_SelectDisplayType_popup,font="Geneva",fSize=7
	PopupMenu Spin_SelectDisplayType_popup,mode=1,popvalue="Current Data",value= #"\"Current Data;Saved results\""
	Button button0,pos={141.00,194.00},size={77.00,31.00},proc=SpinButtonProc_1,title="Save"
	SetVariable setvar5,pos={69.00,152.00},size={37.00,14.00},proc=SpinSetVarProc_1,title=" "
	SetVariable setvar5,value= VG_MN_SavedResults
	TitleBox title1,pos={58.00,151.00},size={70.00,15.00}
	TitleBox title1,labelBack=(65535,65535,65535),frame=0
	TitleBox title1,variable= SG_Mtname,anchor= MT,fixedSize=1
	TitleBox title2,pos={13.00,248.00},size={120.00,15.00}
	TitleBox title2,labelBack=(65535,65535,65535),frame=0
	TitleBox title2,variable= root:SpinAnalysis:SG_info_L,anchor= MT,fixedSize=1
	Button button1,pos={221.00,194.00},size={77.00,31.00},proc=SpinButtonProc_2,title="Kill"
	Button button5,pos={301.00,194.00},size={77.00,31.00},proc=SpinButtonProc_3,title="Info table"
	CheckBox check1,pos={165.00,233.00},size={20.00,16.00},title=" "
	CheckBox check1,variable= VG_check2
	Button Spin_ShowRawData_button,pos={208.00,65.00},size={42.00,16.00},proc=Spin_button_ShowRawSpectra,title="Show"
	Button Spin_ShowRawData_button,fSize=10
	CheckBox check2,pos={243.00,233.00},size={20.00,16.00},disable=2,title=" "
	CheckBox check2,variable= VG_check3
	CheckBox check3,pos={273.00,233.00},size={20.00,16.00},disable=2,title=" "
	CheckBox check3,variable= VG_check4
	SetVariable Spin_Bg_z_setvar,pos={14.00,106.00},size={66.00,14.00},proc=Spin_setvar_ParameterUpdate,title="Bg z"
	SetVariable Spin_Bg_z_setvar,limits={-10000,10000,1},value= root:SpinAnalysis:VG_Bg_z
	SetVariable Spin_Bg_y_setvar,pos={79.00,105.00},size={53.00,14.00},proc=Spin_setvar_ParameterUpdate,title="y"
	SetVariable Spin_Bg_y_setvar,limits={-10000,10000,1},value= root:SpinAnalysis:VG_Bg_y
	Button Spin_done_button,pos={205.00,4.00},size={42.00,16.00},proc=SP_button_done,title="done"
	Button Spin_done_button,fSize=8,fColor=(65535,0,0)
	SetVariable Spin_SelectPrmt_setvar,pos={69.00,152.00},size={37.00,14.00},proc=SpinSetVarProc_1,title=" "
	SetVariable Spin_SelectPrmt_setvar,value= root:SpinAnalysis:VG_MN_SavedResults
EndMacro



Function Spin_SetUPSpinPAnel()

	if (DataFolderRefStatus(dfr) ==0)
		NewDataFolder/O root:SpinAnalysis
	endif
	DFREF dfr = root:SpinAnalysis


	//MottMatrixList
	Make/O/T/N=100 dfr:MottMTList
	Make/O/T/N=100 dfr:MottMTList_info
	Variable/G dfr:FlagVG_TableChoice=1
	SpinMatrixListIndex()    // Mott形式のmatrix リスト
	
	Variable/G  dfr:VG_MN_Mottmatrix=1  //Mott形式のmatrix 番号
	String/G dfr:MN_Mottmatrix	
	String/G dfr:MN_MottmatrixInfo	

	// 各種フラグ
	Variable/G  dfr:FlagVG_TempSaved=1  //tempwにするかsavedresultsにするか
	Variable/G  dfr:FlagVG_GlobalPara=0  //tempwにするかsavedresultsにするか


	// spin解析パラメーターの設定	
	Variable/G dfr:VG_Seff = 0.07
	Variable/G dfr:VG_offset
	Variable/G dfr:VG_InstAssy_y =1
	Variable/G dfr:VG_InstAssy_z =1
	Variable/G dfr:VG_Bg_y=0,dfr:VG_Bg_z=0
	Variable/G dfr:VG_Epass=5

	
	//temporary wavesの設定
	make/d/o/N=(100) dfr:temp1, dfr:temp2, dfr:temp3, dfr:temp4, dfr:temp5
	Wave tmp1 = dfr:temp1
	Wave tmp2 = dfr:temp2
	Wave tmp3 = dfr:temp3
	Wave tmp4 = dfr:temp4

	SetScale/I x -1,1,"", tmp1,tmp2,tmp3,tmp4
	tmp1 = exp(-(x)^2/0.05)
	tmp2 = exp(-(x)^2/0.05)*1.02
	tmp3 = exp(-(x)^2/0.05)
	tmp4 =  exp(-(x)^2/0.05)*1.02
	duplicate/o tmp1 dfr:temp1_nm, dfr:temp2_nm, dfr:temp3_nm, dfr:temp4_nm
	duplicate/o tmp1 dfr:temp_Totz, dfr:temp_Toty
	duplicate/o tmp1 dfr:temp_az, dfr:temp_ay, dfr:temp_pz, dfr:temp_py
	duplicate/o tmp1 dfr:temp_Zup, dfr:temp_Zdn, dfr:temp_Yup, dfr:temp_Ydn

	
	
	//saveする解析結果のパラメーターの保存
	//Make/O/T/N=100 Info_base
	//Make/O/T/N=100 Info_info
	//Make/O/T/N=100 Info_data
	//Make/O/N=100 Info_Epass
	//Make/O/N=100 Info_GlobalFlag
	//Make/O/N=100 Info_sher
	//Make/O/N=100 Info_offset
	//Make/O/N=100 Info_instAy
	//Make/O/N=100 Info_instAz
	//Make/O/N=100 Info_Bg_y
	//Make/O/N=100 Info_Bg_z
	Variable/G  dfr:VG_MN_SavedResults=0
	Variable/G  dfr:VG_Seff_L
	Variable/G dfr:VG_InstAssy_L_y,dfr:VG_InstAssy_L_z
	Variable/G dfr:VG_BG_L_y, dfr:VG_BG_L_z
	Variable/G dfr:VG_Epass_L
	Variable/G dfr:VG_check1
	String/G dfr:SG_info_L

	

	// saved wavesの設定	
	String/G dfr:SG_swavename="temp"
	String/G dfr:SG_Mtname
	String/G dfr:SG_WN1raw,dfr:SG_WN2raw,dfr:SG_WN3raw,dfr:SG_WN4raw
	String/G dfr:SG_WN1,dfr:SG_WN2,dfr:SG_WN3,dfr:SG_WN4
	
	String/G dfr:SG_AnaWN=""
	String/G dfr:SG_AsyWNy,dfr:SG_AsyWNz
	String/G dfr:SG_TotWNy,dfr:SG_TotWNz
	String/G dfr:SG_PolWNy,dfr:SG_PolWNz
	String/G dfr:SG_UpWNy,dfr:SG_DnWNy, dfr:SG_UpWNz,dfr:SG_DnWNz	
	
	
	//All calciulation program用の各種設定
	//Variable/G VG_check2

	//他の解析マクロをactiveにするための設定
	//Variable/G VG_check3
	//Variable/G VG_check4
	//Variable/G VG_snum, VG_enum

	Spin_SetAnalysisWaves()

Endmacro






Function SpinMatrixListIndex()
PauseUpdate; Silent 1

	DFREF dfr = root:SpinAnalysis
	String Mlist
	String MatName1
	Variable ii, i2, flag
	
//	Variable/G FlagVG_TableChoice
	wave/T MottMTList = dfr:MottMTList
//	wave/T Info_wave
//	wave/T Info_data
	
		MottMTList=""
		Mlist=WaveList("*mot",";","DIMS:2,TEXT:0")  + WaveList("*S",";","DIMS:2,TEXT:0")
		ii=0
		Do
			MatName1=stringfromlist(ii,Mlist)
			MottMTList[ii]=MatName1
				
			ii+=1
		while(cmpstr(MatName1,"")!=0)

	
End



Function  SpinMatrixNamePickUP()
	
	DFREF dfr = root:SpinAnalysis

	String  MN
	variable flagS
	wave/T MottMTList = dfr:MottMTList
	NVAR VG_MN_Mottmatrix = dfr:VG_MN_Mottmatrix
	SVAR MN_Mottmatrix = dfr:MN_Mottmatrix
	
	MN = MottMTList[VG_MN_Mottmatrix]
	flagS = cmpstr(MN,"")
	
	if (flagS!=0)
		 MN_Mottmatrix = MN
	endif
	
end



Function MakeTempWaves()

	DFREF dfr = root:SpinAnalysis

	variable flag
	SVAR MN_Mottmatrix = dfr:MN_Mottmatrix
	flag = cmpstr(MN_Mottmatrix,"")

	if (flag==1)
	duplicate/o $MN_Mottmatrix, dfr:Tmpmat
	wave Tmpmat = dfr:Tmpmat
	make/d/o/N=(dimsize (Tmpmat,0)) dfr:temp1, dfr:temp2, dfr:temp3, dfr:temp4//, temp5
	wave temp1 = dfr:temp1
	wave temp2 = dfr:temp2
	wave temp3 = dfr:temp3
	wave temp4 = dfr:temp4

	
	temp1=Tmpmat[p][0]
	temp2=Tmpmat[p][1]
	temp3=Tmpmat[p][2]
	temp4=Tmpmat[p][3]
//	temp5=Tmpmat[p][0]
	
	variable xstart, xdelta
	xstart = DimOffset(Tmpmat,0)
	xdelta = Dimdelta(Tmpmat,0)
	
	SetScale/P x xstart, xdelta,"", temp1
	SetScale/P x xstart, xdelta,"", temp2
	SetScale/P x xstart, xdelta,"", temp3
	SetScale/P x xstart, xdelta,"", temp4
	
	duplicate/o temp1 dfr:temp1_nm, dfr:temp2_nm, dfr:temp3_nm, dfr:temp4_nm
	duplicate/o temp1 dfr:temp_Totz, dfr:temp_Toty
	duplicate/o temp1 dfr:temp_az, dfr:temp_ay, dfr:temp_pz, dfr:temp_py
	duplicate/o temp1 dfr:temp_Zup, dfr:temp_Zdn, dfr:temp_Yup, dfr:temp_Ydn

	
	endif

	
endmacro




Function Spin_setvar_ParameterUpdate(ctrlName,varNum,varStr,varName) : SetVariableControl
	String ctrlName
	Variable varNum
	String varStr
	String varName
	
	MakeTempWaves()
	SpinCalcForTemp()

End






Function Spin_popup_SelectDisplayType(ctrlName,popNum,popStr) : PopupMenuControl
	String ctrlName
	Variable popNum
	String popStr
	
	Variable/G 	FlagVG_TempSaved 
	
	FlagVG_TempSaved = popNum
	Spin_SetAnalysisWaves()
//	Execute "SpinCalc()"


End










Function SpinCalcForTemp()

	DFREF dfr = root:SpinAnalysis

	wave temp1 = dfr:temp1,temp2= dfr:temp2,temp3= dfr:temp3,temp4 = dfr:temp4
	wave temp1_nm = dfr:temp1_nm, temp2_nm= dfr:temp2_nm, temp3_nm= dfr:temp3_nm, temp4_nm= dfr:temp4_nm
	wave temp_Totz = dfr:temp_Totz, temp_Toty = dfr:temp_Toty
	wave temp_az = dfr:temp_az, temp_ay= dfr:temp_ay, temp_pz= dfr:temp_pz, temp_py= dfr:temp_py
	wave temp_Zup = dfr:temp_Zup, temp_Zdn = dfr:temp_Zdn, temp_Yup = dfr:temp_Yup, temp_Ydn = dfr:temp_Ydn

	NVAR VG_Seff = dfr:VG_Seff, VG_offset = dfr:VG_offset
	NVAR VG_InstAssy_z = dfr:VG_InstAssy_z, VG_InstAssy_y = dfr:VG_InstAssy_y
	NVAR VG_Bg_y = dfr:VG_Bg_y,VG_Bg_z = dfr:VG_Bg_z
	SVAR MN_Mottmatrix = dfr:MN_Mottmatrix
	NVAR VG_MN_Mottmatrix = dfr:VG_MN_Mottmatrix
//	wave storeMspin


///////////   Set temp wave   ///////////////////
	duplicate/o $MN_Mottmatrix dfr:storeMspin
	wave storeMspin = dfr:storeMspin
	temp1=storeMspin[p][0]
	temp2=storeMspin[p][1]
	temp3=storeMspin[p][2]
	temp4=storeMspin[p][3]

////////    BG subraction    /////////////////////
	wave Info_Bg_y = dfr:Info_Bg_y, Info_Bg_z =dfr:Info_Bg_z
	NVAR FlagVG_TableChoice = dfr:FlagVG_TableChoice

	switch (FlagVG_TableChoice)
		case 1:
			temp2 = temp2 -VG_Bg_z
			temp4 = temp4 -VG_Bg_y
		break
		case 2:
			temp2 = temp2 -VG_Bg_z
			temp4 = temp4 -VG_Bg_y
		break
		case 3:
			temp2 = temp2 - Info_Bg_z[VG_MN_Mottmatrix]
			temp4 = temp4 -Info_Bg_y[VG_MN_Mottmatrix]
		break
	endswitch
		
////////           Normalization           //////////////
	temp1_nm=temp1* VG_InstAssy_z
	temp2_nm=temp2 
	temp3_nm=temp3 * VG_InstAssy_y
	temp4_nm=temp4


////////  Calcurate Asym & Pol function  /////////////
	temp_Totz = (temp2_nm) + (temp1_nm)
	temp_Toty = (temp4_nm) + (temp3_nm)

	temp_az =((temp2_nm)-(temp1_nm))/((temp_Totz)+VG_offset)
	temp_ay=((temp4_nm)-(temp3_nm))/((temp_Toty)+VG_offset)
	
	temp_py = temp_ay / VG_Seff
	temp_pz = temp_az / VG_Seff



////////  Calcurate Spin-resolved function  /////////////	
	 temp_Zup= (temp_Totz)*(1+(temp_pz))/2
	 temp_Zdn= (temp_Totz)*(1-(temp_pz))/2
	 temp_Yup = (temp_Toty)*(1+(temp_py))/2
	 temp_Ydn = (temp_Toty)*(1-(temp_py))/2

End






Function Spin_popup_SelectEpass(ctrlName,popNum,popStr) : PopupMenuControl
	String ctrlName
	Variable popNum
	String popStr
	
	DFREF dfr = root:SpinAnalysis

	NVAR 	VG_Epass = dfr:VG_Epass
	
	VG_Epass = popNum
	Spin_normalization2()
	SpinCalcForTemp()
	
End



Function Spin_normalization2()

	DFREF dfr = root:SpinAnalysis

	NVAR EP = dfr:VG_Epass

	NVAR VG_InstAssy_y = dfr:VG_InstAssy_y ,VG_InstAssy_z = dfr:VG_InstAssy_z
	variable Int1,Int2, Int3 ,Int4
		
		If (EP==1)
			Int1 = 267.142
			Int2 = 307.607
			Int3 = 292.937
			Int4 = 297.563	
		Endif
			
		If (EP==2)
			Int1=815.27
			Int2=943.484
			Int3=911.302
			Int4=921.928// EP2eV
		Endif
		
		If (EP==3)
			Int1=3937.24
			Int2=4610.28
			Int3=4422.13
			Int4=4499.84// EP5eV
		Endif
		
		If (EP==4)
			Int1=7957.88
			Int2=9423.97
			Int3=9121.15
			Int4=9233.25// EP10eV
		Endif


		VG_InstAssy_z = Int2/Int1
		VG_InstAssy_y = Int4/Int3
		
End




Function Spin_button_ShowAssyData(ctrlName) : ButtonControl
	String ctrlName
	
	DFREF dfr = root:SpinAnalysis
		
	SVAR SG_AsyWNy = dfr:SG_AsyWNy,SG_AsyWNz = dfr:SG_AsyWNz

	display  dfr:$SG_AsyWNy
	ModifyGraph zero(left)=2
	display  dfr:$SG_AsyWNz 
	ModifyGraph zero(left)=2
	
End

Function Spin_button_ShowPolData(ctrlName) : ButtonControl
	String ctrlName
	
	DFREF dfr = root:SpinAnalysis
		
	SVAR SG_PolWNy = dfr:SG_PolWNy,SG_PolWNz = dfr:SG_PolWNz

	display  dfr:$SG_PolWNy 
	ModifyGraph zero(left)=2
	SetAxis left -1.1,1.1
	display  dfr:$SG_PolWNz 
	ModifyGraph zero(left)=2
	SetAxis left -1.1,1.1
	
End


Function Spin_button_ShowSpinARPES(ctrlName) : ButtonControl
	String ctrlName
	
	DFREF dfr = root:SpinAnalysis
	
	SVAR SG_UpWNy = dfr:SG_UpWNy,SG_DnWNy = dfr:SG_DnWNy, SG_UpWNz = dfr:SG_UpWNz,SG_DnWNz = dfr:SG_DnWNz

	display  dfr:$SG_UpWNz,dfr:$SG_DnWNz 
	ModifyGraph rgb($SG_UpWNz)=(0,0,0),rgb($SG_DnWNz)=(65535,0,0)
	ModifyGraph mode=4,marker=8,msize=2,opaque=1
	Legend/C/N=text0/F=0/A=MC/X=-30/Y=37

	
	display  dfr:$SG_UpWNy,dfr:$SG_DnWNy 
	ModifyGraph rgb($SG_UpWNy)=(0,0,0),rgb($SG_DnWNy)=(65535,0,0)
	ModifyGraph mode=4,marker=8,msize=2,opaque=1
	Legend/C/N=text0/F=0/A=MC/X=-30/Y=37
		
	
End





Function SpinButtonProc_1(ctrlName) : ButtonControl
	String ctrlName
	
	
	Execute "SaveParameters()"

End


Macro SaveParameters (base, info)
string base, info
variable global

	variable inum, flag
	string  WN1, WN2, WN3, WN4
	string  WN1raw,WN2raw,WN3raw,WN4raw
	string AsyWNy, AsyWNz, TotWNy, TotWNz
	string PolWNy, PolWNz
	string UpWNy, DnWNy, UpWNz, DnWNz
	
	
	inum=-1
	Do
		inum+=1
		flag = cmpstr(Info_base[inum],"")
	while (flag==1)
	
	Info_base[inum] = base
	Info_info[inum] = info
	Info_data[inum] = MN_Mottmatrix	
	Info_Epass[inum] = VG_Epass
	Info_GlobalFlag[inum] = global
	Info_sher[inum] = VG_Seff
	Info_instAy[inum] = VG_InstAssy_y
	Info_instAz[inum] = VG_InstAssy_z
	Info_Bg_y[inum] = VG_Bg_y
	Info_Bg_z[inum] = VG_Bg_z

	WN1raw = base +"_r1"
	WN2raw = base +"_r2"
	WN3raw = base +"_r3"
	WN4raw = base +"_r4"
	duplicate/o temp1 $WN1raw
	duplicate/o temp2 $WN2raw
	duplicate/o temp3 $WN3raw
	duplicate/o temp4 $WN4raw
	
	
	WN1 = base + "_nm1"
	WN2 = base + "_nm2"
	WN3 = base + "_nm3"
	WN4 = base + "_nm4"
	duplicate/o temp1_nm $WN1
	duplicate/o temp2_nm $WN2
	duplicate/o temp3_nm $WN3
	duplicate/o temp4_nm $WN4
	
	AsyWNy = base + "_ay"
	AsyWNz = base + "_az"
	TotWNy = base + "_ty"
	TotWNz = base + "_tz"
	PolWNy = base + "_py"
	PolWNz = base + "_pz"
	duplicate/o temp_ay $AsyWNy 
	duplicate/o temp_az $AsyWNz 
	duplicate/o temp_Toty $TotWNy
	duplicate/o temp_Totz $TotWNz
	duplicate/o temp_py $PolWNy  
	duplicate/o temp_pz $PolWNz 

	UpWNy= base + "_Yup"
	DnWNy= base + "_Ydn"
	UpWNz= base + "_Zup"
	DnWNz= base + "_Zdn"
	duplicate/o temp_Yup $UpWNy 
	duplicate/o temp_Ydn $DnWNy 
	duplicate/o temp_Zup $UpWNz 
	duplicate/o temp_Zdn $DnWNz


endmacro




Function Spin_SetAnalysisWaves()
	
	DFREF dfr = root:SpinAnalysis
	NVAR FlagVG_TempSaved= dfr:FlagVG_TempSaved
	NVAR vgn = dfr:VG_MN_SavedResults
	wave/T info_base = dfr:Info_base, info_data=dfr:Info_data
	string base = Info_base[vgn]
	string dataname = Info_data[vgn]
		
	PauseUpdate; Silent 1
	if  (FlagVG_TempSaved==1)
	
		String/G dfr:SG_WN1raw = "temp1"
		String/G dfr:SG_WN2raw = "temp2"
		String/G dfr:SG_WN3raw = "temp3"
		String/G dfr:SG_WN4raw = "temp4"
	
		String/G dfr:SG_WN1 = "temp1_nm"
		String/G dfr:SG_WN2 = "temp2_nm"
		String/G dfr:SG_WN3 = "temp3_nm"
		String/G dfr:SG_WN4 = "temp4_nm"
	
		String/G dfr:SG_AsyWNy = "temp_ay"
		String/G dfr:SG_AsyWNz = "temp_az"
		String/G dfr:SG_TotWNy =  "temp_Toty"
		String/G dfr:SG_TotWNz = "temp_Totz"
		String/G dfr:SG_PolWNy = "temp_py"
		String/G dfr:SG_PolWNz = "temp_pz"
		String/G dfr:SG_UpWNy = "temp_Yup"
		String/G dfr:SG_DnWNy = "temp_Ydn"
		String/G dfr:SG_UpWNz = "temp_Zup"
		String/G dfr:SG_DnWNz = "temp_Zdn"	
		
	endif 


	if  (FlagVG_TempSaved==2)

		String/G dfr:SG_swavename = base
		String/G dfr:SG_Mtname = dataname
		
		String/G dfr:SG_WN1raw =  base +"_r1"
		String/G dfr:SG_WN2raw =  base +"_r2"
		String/G dfr:SG_WN3raw = base +"_r3"
		String/G dfr:SG_WN4raw = base +"_r4"
	
		String/G dfr:SG_WN1 = base + "_nm1"
		String/G dfr:SG_WN2 = base + "_nm2"
		String/G dfr:SG_WN3 = base + "_nm3"
		String/G dfr:SG_WN4 = base + "_nm4"
		
		String/G dfr:SG_AsyWNy = base + "_ay"
		String/G dfr:SG_AsyWNz = base + "_az"
		String/G dfr:SG_TotWNy = base + "_ty"
		String/G dfr:SG_TotWNz = base + "_tz"
		String/G dfr:SG_PolWNy = base + "_py"
		String/G dfr:SG_PolWNz = base + "_pz"
		
		String/G dfr:SG_UpWNy= base + "_Yup"
		String/G dfr:SG_DnWNy= base + "_Ydn"
		String/G dfr:SG_UpWNz= base + "_Zup"
		String/G dfr:SG_DnWNz= base + "_Zdn"
		
	endif 
End



Macro LocalParemeterUPdate()

	VG_Seff_L =  Info_sher[VG_MN_SavedResults]
	VG_InstAssy_L_y =  Info_instAy[VG_MN_SavedResults]
	VG_InstAssy_L_z =  Info_instAz[VG_MN_SavedResults]
	VG_Bg_L_y =  Info_Bg_y[VG_MN_SavedResults]
	VG_Bg_L_z =  Info_Bg_z[VG_MN_SavedResults]
	VG_Epass_L =  Info_Epass[VG_MN_SavedResults]
	SG_info_L =Info_info[VG_MN_SavedResults]
	VG_check1 = Info_GlobalFlag[VG_MN_SavedResults]
	
endmacro



Function SpinCalcLocal(DataNum)
Variable DataNum
	Variable InstAssy_z,InstAssy_y
	Variable Seff
	Variable offset
	Variable check
	Variable Bg_z, Bg_y
	
	Wave Info_globalFlag
//	Variable/G VG_check1 
	check = Info_globalFlag[DataNum]  ////////////////////   Global or Local Setting
	
//	Variable/G VG_InstAssy_L_y , VG_InstAssy_L_z
//	Variable/G  VG_Seff_L, VG_offset, VG_BG_L_z, VG_BG_L_y
	wave Info_instAz, Info_instAy
	wave Info_Bg_y, Info_Bg_z
	wave Info_sher, Info_offset
	
	if (check==0)   ///////////////////   case for Local
		InstAssy_y = Info_instAy[DataNum]
		InstAssy_z = 	 Info_instAz[DataNum]
		Seff = Info_sher[DataNum]
		offset =  Info_offset[DataNum]
		Bg_z =  Info_Bg_z[DataNum]
		Bg_y =  Info_Bg_y[DataNum]
	endif
	
	Variable/G VG_InstAssy_y , VG_InstAssy_z
	Variable/G  VG_Seff, VG_offset, VG_BG_z, VG_BG_y
	if (check==1)  ///////////////////   case for Grobal
		InstAssy_y =  VG_InstAssy_y 
		InstAssy_z = VG_InstAssy_z 
		Seff =  VG_Seff
		offset = VG_offset
		Bg_z =  Info_Bg_z[DataNum]
		Bg_y =  Info_Bg_y[DataNum]
	//	Bg_z = VG_BG_z
	//	Bg_y = VG_BG_y
	endif

	String  base, basematN
	wave/T Info_base, Info_data
	base = Info_base[DataNum]
	basematN =  Info_data[DataNum]
//	base = Info_base[VG_MN_SavedResults]
	if (cmpstr(base,"")==0)
		return -1
	endif
	duplicate/o $basematN BaseMat

	/////////		Derive waves			//////////////
	String wr1,wr2,wr3,wr4
	wave w_r1,w_r2,w_r3,w_r4
	wr1 = base + "_r1"
	wr2 = base + "_r2"
	wr3 = base + "_r3"
	wr4 = base + "_r4"
	duplicate/o  $wr1 w_r1
	duplicate/o  $wr2 w_r2
	duplicate/o  $wr3 w_r3
	duplicate/o  $wr4 w_r4
	w_r1[] = BaseMat[p][0]
	w_r2[] = BaseMat[p][1]
	w_r3[] = BaseMat[p][2]
	w_r4[] = BaseMat[p][3]
	duplicate/o  w_r1 $wr1
	duplicate/o  w_r2 $wr2 
	duplicate/o  w_r3 $wr3
	duplicate/o  w_r4 $wr4

	////////           Normalization           //////////////
	String  nr1, nr2, nr3, nr4
	wave w_nr1,w_nr2,w_nr3,w_nr4
	nr1 = base + "_nm1"
	nr2 = base + "_nm2"
	nr3 = base + "_nm3"
	nr4 = base + "_nm4"
	duplicate/o  $nr1 w_nr1
	duplicate/o  $nr2 w_nr2
	duplicate/o  $nr3 w_nr3
	duplicate/o  $nr4 w_nr4
	w_nr1=w_r1* InstAssy_z
	w_nr2=w_r2 -Bg_z
	w_nr3=w_r3 * InstAssy_y
	w_nr4=w_r4-Bg_y 
	duplicate/o  w_nr1 $nr1
	duplicate/o  w_nr2 $nr2
	duplicate/o  w_nr3 $nr3
	duplicate/o  w_nr4 $nr4

	////////  Calcurate Asym & Pol function  /////////////
	String Tz,Ty, Az,Ay, Pz,Py
	wave w_tz,w_ty,w_az,w_zy,w_pz,w_py
	Tz = base + "_tz"
	Ty = base + "_ty"
	Az = base + "_az"
	Ay = base + "_ay"
	Pz = base + "_pz"
	Py = base + "_py"
	duplicate/o  $Tz w_tz
	duplicate/o  $Ty w_ty
	duplicate/o  $Az w_az
	duplicate/o  $Ay w_ay
	duplicate/o  $Pz w_pz
	duplicate/o  $Py w_py	
	w_ty =  w_nr3 +  w_nr4
	w_tz =  w_nr1 +  w_nr2
	w_az=(w_nr2-w_nr1)/(	w_tz +offset)
	w_ay=(w_nr4-w_nr3)/(	w_ty +offset)
	w_py =  w_ay / Seff
	w_pz =  w_az / Seff
	duplicate/o   w_tz $Tz
	duplicate/o   w_ty $Ty
	duplicate/o  w_az $Az 
	duplicate/o  w_ay $Ay 
	duplicate/o  w_pz $Pz 
	duplicate/o  w_py $Py 	


	////////  Calcurate Spin-resolved function  /////////////	
	String  Zup,Zdn,Yup,Ydn
	wave w_zup,w_zdn,w_yup,w_ydn
	Zup = base + "_zup"
	Zdn = base + "_zdn"
	Yup = base + "_yup"
	Ydn = base + "_ydn"
	duplicate/o   $Zup w_zup 
	duplicate/o   $Zdn w_zdn
	duplicate/o   $Yup w_yup 
	duplicate/o   $Ydn w_ydn 	
	w_zup= w_tz*(1+ w_pz)/2
	w_zdn= w_tz*(1-w_pz)/2
	w_yup= w_ty*(1+w_py)/2
	w_ydn= w_ty*(1-w_py)/2
	duplicate/o   w_zup $Zup
	duplicate/o   w_zdn $Zdn
	duplicate/o  w_yup $Yup 
	duplicate/o  w_ydn $Ydn 	

Endmacro



Function SpinCheckProc_1(ctrlName,checked) : CheckBoxControl
	String ctrlName
	Variable checked
	
	wave  Info_GlobalFlag
	Variable/G  VG_check1	
	Variable /G VG_MN_SavedResults
	
	Variable flag2,flag3
	Variable/G VG_check3,VG_check4 
	
	flag2=VG_check3
	flag3=VG_check4 
	
	Info_GlobalFlag[ VG_MN_SavedResults]=VG_check1
	
	SpinCalcLocal(VG_MN_SavedResults)


		if (flag2==1)
			Execute "CalcPol()"
		endif
		
		if (flag3==1)

		endif


End



Macro UPdateInfo()

	info_sher[VG_MN_SavedResults] =	VG_Seff_L 
	Info_instAy[VG_MN_SavedResults] = VG_InstAssy_L_y 
	Info_instAz[VG_MN_SavedResults] = VG_InstAssy_L_z
	Info_Bg_y[VG_MN_SavedResults] = VG_Bg_L_y 
	Info_Bg_z[VG_MN_SavedResults] = VG_Bg_L_z
	Info_GlobalFlag[VG_MN_SavedResults] = 	VG_check1
	
endmacro




Function SpinButtonProc_2(ctrlName) : ButtonControl
	String ctrlName
	
	Execute "RemoveInfo()"
	Execute "LocalParemeterUPdate()"
	Spin_SetAnalysisWaves()
End


Macro RemoveInfo(check)
variable inum	= VG_MN_SavedResults
string dataNm =  Info_base[inum]
variable check
Prompt check, "Are you sure of killing the saved results of data#" + num2str(inum) +"(" + dataNm + ")  ?", popup,"yes;no"	
	
	print check
	
	if (check==1)
	DeletePoints inum,1, Info_base
	DeletePoints inum,1,	Info_info
	DeletePoints inum,1,	Info_data
	DeletePoints inum,1,	Info_Epass
	DeletePoints inum,1,	Info_GlobalFlag
	DeletePoints inum,1,Info_sher
	DeletePoints inum,1,	Info_instAy
	DeletePoints inum,1,	Info_instAz
	DeletePoints inum,1,	Info_Bg_y
	DeletePoints inum,1,	Info_Bg_z
	endif

Endmacro





Function UpdateSaveResluts()
	variable Endnum
	variable inum
	variable flag
	PauseUpdate; Silent 1
	wave/T Info_base
	wave Info_GlobalFlag
	string base
	
	////////// endnum 設定  ////////////////
	inum=0
	Do
		inum+=1
		flag = cmpstr(Info_base[inum],"")
	while (flag==1)

	Endnum = inum
	
	inum = 0
	Do
		base = Info_base[inum]
		flag = 	Info_GlobalFlag[inum]
		
			if (flag == 1)      //  globalがactiveであるsaved resultsに対して再計算
				
			SpinCalcLocal(inum)
				
		
			endif  //  globalがactiveであるsaved resultsに対して再計算  [ここまで] ////////////
	
	
		inum+=1
	while (inum<Endnum)
	

end









Function Spin_button_ShowRawSpectra(ctrlName) : ButtonControl
	String ctrlName

	DFREF dfr = root:SpinAnalysis

	SVAR SG_WN1raw = dfr:SG_WN1raw ,SG_WN2raw= dfr:SG_WN2raw ,SG_WN3raw= dfr:SG_WN3raw ,SG_WN4raw= dfr:SG_WN4raw 
	
	display  dfr:$SG_WN1raw,dfr:$SG_WN2raw
	ModifyGraph rgb($SG_WN2raw)=(0,0,0),rgb($SG_WN1raw)=(65535,0,0)
	Legend/C/N=text0/F=0/A=MC/X=-30/Y=37
	TextBox/C/N=text1/F=0/A=LT/X=10/Y=25 "Z-direction rawdata"

	display  dfr:$SG_WN3raw,dfr:$SG_WN4raw
	ModifyGraph rgb($SG_WN4raw)=(0,0,0),rgb($SG_WN3raw)=(65535,0,0)
	Legend/C/N=text0/F=0/A=MC/X=-30/Y=37
	TextBox/C/N=text1/F=0/A=LT/X=10/Y=25 "Y-direction rawdata"

End


Function Spin_button_ShowNormSpectra(ctrlName) : ButtonControl
	String ctrlName

	DFREF dfr = root:SpinAnalysis

	SVAR SG_WN1 = dfr:SG_WN1 ,SG_WN2 = dfr:SG_WN2, SG_WN3= dfr:SG_WN3, SG_WN4= dfr:SG_WN4
	
	display  dfr:$SG_WN1,dfr:$SG_WN2
	ModifyGraph rgb($SG_WN2)=(0,0,0),rgb($SG_WN1)=(65535,0,0)
	Legend/C/N=text0/F=0/A=MC/X=-30/Y=37
	TextBox/C/N=text1/F=0/A=LT/X=10/Y=25 "Z-direction normdata"

	display  dfr:$SG_WN3,dfr:$SG_WN4
	ModifyGraph rgb($SG_WN4)=(0,0,0),rgb($SG_WN3)=(65535,0,0)
	Legend/C/N=text0/F=0/A=MC/X=-30/Y=37
	TextBox/C/N=text1/F=0/A=LT/X=10/Y=25 "Y-direction normdata"
	

End

Function SpinSetVarProc3(ctrlName,varNum,varStr,varName) : SetVariableControl
	String ctrlName
	Variable varNum
	String varStr
	String varName
	
	Variable flag, flag2,flag3
	Variable/G VG_check2,VG_check3,VG_check4 

	flag = VG_check2
	flag2 = VG_check3
	flag3= VG_check4


	SpinCalcForTemp()
	
		if (flag ==1)
			UpdateSaveResluts()
		endif
		
		if (flag2==1)
			Execute "CalcPol()"
		endif
		
		if (flag3==1)

		endif
	
End










///////////////////////////////////////////////////

Macro CalcPol()
	Variable snum,enum

	snum=VG_snum
	enum=VG_enum

	Pz_phai[0]= sum(DP30_pz,snum, enum)/(enum-snum)*0.01
	Pz_phai[1]= sum(D0_pz,snum, enum)/(enum-snum)*0.01
	Pz_phai[2]= sum(D30_pz,snum, enum)/(enum-snum)*0.01
	Pz_phai[3]= sum(D60_pz,snum, enum)/(enum-snum)*0.01
	Pz_phai[4]= sum(D90_pz,snum, enum)/(enum-snum)*0.01
	Pz_phai[5]= sum(D120_pz,snum, enum)/(enum-snum)*0.01
	Pz_phai[6]= sum(D150_pz,snum, enum)/(enum-snum)*0.01
	Pz_phai[7]= sum(D0re_pz,snum, enum)/(enum-snum)*0.01
	Pz_phai[8]= sum(temp_pz,snum, enum)/(enum-snum)*0.01

	
	Py_phai[0]= sum(DP30_py,snum, enum)/(enum-snum)*0.01
	Py_phai[1]= sum(D0_py,snum, enum)/(enum-snum)*0.01
	Py_phai[2]= sum(D30_py,snum, enum)/(enum-snum)*0.01
	Py_phai[3]= sum(D60_py,snum, enum)/(enum-snum)*0.01
	Py_phai[4]= sum(D90_py,snum, enum)/(enum-snum)*0.01
	Py_phai[5]= sum(D120_py,snum, enum)/(enum-snum)*0.01
	Py_phai[6]= sum(D150_py,snum, enum)/(enum-snum)*0.01
	Py_phai[7]= sum(D0re_py,snum, enum)/(enum-snum)*0.01
	Py_phai[8]= sum(temp_py,snum, enum)/(enum-snum)*0.01


	make/o/N=7 Pz_line, Py_line
	SetScale/P x -30,30,"", Pz_line,Py_line
	Pz_line[0,6]=Pz_phai
	Py_line[0,6]=Py_phai


Endmacro


Function SpinSetVarProc_2(ctrlName,varNum,varStr,varName) : SetVariableControl
	String ctrlName
	Variable varNum
	String varStr
	String varName
		
	Variable flag2,flag3
	Variable/G VG_check3,VG_check4 
	
	flag2=VG_check3
	flag3=VG_check4 
	
	String/G SG_Mtname
	Variable/G VG_MN_SavedResults
	if ( cmpstr( SG_Mtname,"")==1)
		SpinCalcLocal(VG_MN_SavedResults)
	endif
	
	Execute " UPdateInfo()"
	
		if (flag2==1)
			Execute "CalcPol()"
		endif
		
		if (flag3==1)

		endif


End

Function SpinSetVarProc_13(ctrlName,varNum,varStr,varName) : SetVariableControl
	String ctrlName
	Variable varNum
	String varStr
	String varName

	Execute "CalcPol()"


End


Function SpinCalcForSmthTemp()
wave temp1,temp2,temp3,temp4 
wave temp1_nm, temp2_nm, temp3_nm, temp4_nm
wave temp_Totz, temp_Toty
wave temp_az, temp_ay, temp_pz, temp_py
wave  temp_Zup, temp_Zdn, temp_Yup, temp_Ydn

variable/G VG_Seff, VG_offset
variable/G VG_InstAssy_z, VG_InstAssy_y

////////           Normalization           //////////////
	temp1_nm=temp1* VG_InstAssy_z
	temp2_nm=temp2 
	temp3_nm=temp3 * VG_InstAssy_y
	temp4_nm=temp4


////////  Calcurate Asym & Pol function  /////////////
	temp_Totz = (temp2_nm) + (temp1_nm)
	temp_Toty = (temp4_nm) + (temp3_nm)


////////  Calcurate Spin-resolved function  /////////////	
	 temp_Zup= (temp_Totz)*(1+(temp_pz))/2
	 temp_Zdn= (temp_Totz)*(1-(temp_pz))/2
	 temp_Yup = (temp_Toty)*(1+(temp_py))/2
	 temp_Ydn = (temp_Toty)*(1-(temp_py))/2

End


Macro PolarizationSmooth_temp (cutx, smN, ratio)
Variable cutx=71
Variable  smN=10
Variable ratio=0.5
	
	SpinCalcForTemp()

	Integrate temp_py/D=temp_py_INT
	Integrate temp_pz/D=temp_pz_INT
	
	Duplicate/O temp_py_INT,temp_py_INT_smth
	Smooth smN, temp_py_INT_smth
	Duplicate/O temp_pz_INT,temp_pz_INT_smth
	Smooth smN, temp_pz_INT_smth
	
	temp_py_INT_smth[cutx,] = temp_py_INT
	temp_pz_INT_smth[cutx,] = temp_pz_INT

	
	Differentiate temp_py_INT_smth/D=temp_py_INT_smth_DIF
	Differentiate temp_pz_INT_smth/D=temp_pz_INT_smth_DIF
	
	duplicate/o temp_py temp_py_raw
	duplicate/o temp_pz temp_pz_raw

	temp_py = temp_py_INT_smth_DIF * ratio  + temp_py_raw * (1-ratio)
	temp_pz = temp_pz_INT_smth_DIF * ratio  + temp_pz_raw * (1-ratio)
	
	SpinCalcForSmthTemp()
	
endmacro



Macro PolarizationSmooth_Local (cutx, smN, ratio)
Variable cutx=71
Variable  smN=10
Variable ratio=0.3
	
	Variable/G VG_MN_SavedResults
	if ( cmpstr( SG_Mtname,"")==1)
		SpinCalcLocal(VG_MN_SavedResults)
	endif
	
	duplicate/o $SG_PolWNy tempL_py
	duplicate/o $SG_PolWNz tempL_pz


	Integrate tempL_py/D=tempL_py_INT
	Integrate tempL_pz/D=tempL_pz_INT
	
	Duplicate/O tempL_py_INT,tempL_py_INT_smth
	Smooth smN, tempL_py_INT_smth
	Duplicate/O tempL_pz_INT,tempL_pz_INT_smth
	Smooth smN, tempL_pz_INT_smth
	
	tempL_py_INT_smth[cutx,] = tempL_py_INT
	tempL_pz_INT_smth[cutx,] = tempL_pz_INT

	
	Differentiate tempL_py_INT_smth/D=tempL_py_INT_smth_DIF
	Differentiate tempL_pz_INT_smth/D=tempL_pz_INT_smth_DIF
	
	duplicate/o tempL_py tempL_py_raw
	duplicate/o tempL_pz tempL_pz_raw

	tempL_py = tempL_py_INT_smth_DIF * ratio  + tempL_py_raw * (1-ratio)
	tempL_pz = tempL_pz_INT_smth_DIF * ratio  + tempL_pz_raw * (1-ratio)
	
	 $SG_PolWNy = tempL_py
	 $SG_PolWNz = tempL_pz

	
	SpinCalcForSmthLocal()
	
endmacro



Macro SpinCalcForSmthLocal()
	Variable InstAssy_z,InstAssy_y
	Variable Seff
	Variable offset
	Variable check
	
	check = VG_check1
	
	if (VG_check1==0)
		InstAssy_y = 	VG_InstAssy_L_y 
		InstAssy_z = 	VG_InstAssy_L_z
		Seff = VG_Seff_L
		offset = VG_offset
	endif
	
	if (VG_check1==1)
		InstAssy_y =  VG_InstAssy_y 
		InstAssy_z = VG_InstAssy_z 
		Seff =  VG_Seff
		offset = VG_offset
	endif

	////////           Normalization           //////////////
	$SG_WN1=$SG_WN1raw * InstAssy_z
	$SG_WN2=$SG_WN2raw 
	$SG_WN3=$SG_WN3raw * InstAssy_y
	$SG_WN4=$SG_WN4raw


	////////  Calcurate Asym & Pol function  /////////////
	$SG_TotWNz = ($SG_WN2) + ($SG_WN1)
	$SG_TotWNy = ($SG_WN4) + ($SG_WN3)

	////////  Calcurate Spin-resolved function  /////////////	
	$SG_UpWNz= ($SG_TotWNz)*(1+($SG_PolWNz))/2
	$SG_DnWNz= ($SG_TotWNz)*(1-($SG_PolWNz))/2
	$SG_UpWNy= ($SG_TotWNy)*(1+($SG_PolWNy))/2
	$SG_DnWNy= ($SG_TotWNy)*(1-($SG_PolWNy))/2


Endmacro



macro SaveSmoothTemp(base, F_display)
String base
variable F_display=0

	String PolWNy, PolWNz, PolRAWWNy, PolRAWWNz,PolSMTWNy ,PolSMTWNz
	String UpWNy, DnWNy, UpWNz, DnWNz
	
	
	PolWNy = base + "_py"
	PolWNz = base + "_pz"
	duplicate/o temp_py $PolWNy  
	duplicate/o temp_pz $PolWNz 
		
	PolRAWWNy = base + "_RAWpy"
	PolRAWWNz = base + "_RAWpz"
	duplicate/o temp_py_raw $PolRAWWNy  
	duplicate/o temp_pz_raw $PolRAWWNz 
	
	PolSMTWNy = base + "_Spy"
	PolSMTWNz = base + "_Spz"
	duplicate/o temp_py_INT_smth_DIF  $PolSMTWNy  
	duplicate/o temp_pz_INT_smth_DIF  $PolSMTWNz 

	UpWNy= base + "_Yup"
	DnWNy= base + "_Ydn"
	UpWNz= base + "_Zup"
	DnWNz= base + "_Zdn"
	duplicate/o temp_Yup $UpWNy 
	duplicate/o temp_Ydn $DnWNy 
	duplicate/o temp_Zup $UpWNz 
	duplicate/o temp_Zdn $DnWNz
	
	
	if (F_display==1)
	Display $UpWNy ,$DnWNy
	ModifyGraph mode=4,marker=8,msize=2.5,opaque=1
	ModifyGraph rgb($UpWNy)=(0,0,0)
	Legend/C/N=text0/F=0/A=MC

	Display $UpWNz ,$DnWNz
	ModifyGraph mode=4,marker=8,msize=2.5,opaque=1
	ModifyGraph rgb($UpWNz)=(0,0,0)
	Legend/C/N=text0/F=0/A=MC
	
	Display $PolRAWWNy, $PolSMTWNy  
	ModifyGraph rgb($PolSMTWNy)=(0,0,0)
	SetAxis left -1,1
	ModifyGraph zero(left)=2
	
	Display $PolRAWWNz, $PolSMTWNz
	ModifyGraph rgb($PolSMTWNz)=(0,0,0)
	SetAxis left -1,1
	ModifyGraph zero(left)=2
	endif
	
endmacro


Macro GraphSoph(ef)
variable ef=0

	Label left "\\F'Times'\\Z18Intensity (arb. units)"
	ModifyGraph tick(left)=3,mirror(left)=2,noLabel(left)=1
	
	Label bottom "\\F'Times'\\Z18Binding Energy (eV)"
	ModifyGraph mirror=2
	
	ModifyGraph margin(left)=40
	
	
	String WN
	variable n
	variable xstep, xstart
	Do
	WN=WaveName("",n,1)
	
	xstart =  dimoffset ($WN,0)
	xstep = dimdelta ($WN,0)
	
	xstart = xstart - ef
	
	SetScale/P x xstart,xstep,"", $WN

	n+=1
	while( WaveExists( $WaveName("",n,1) ) != 0 )
	
	
	
	
endmacro




Macro PolarizationProfile (angleWN,pzWN,pyWN,pzErWN,pyErWN,SrDataWN, IntegS,IntegE)
String angleWN="theta_angle"
String pzWN="pz_wave"
String pyWN="py_wave"
String pzErWN="pz_error"
String pyErWN="py_error"
String SrDataWN = "textwave1"
Variable IntegS=0, IntegE=10


	PauseUpdate; Silent 1
	
	
	Variable ii, endp
	ii=0
	endp = dimsize ($angleWN,0)

	
	String SrcMatname
	
	Variable pzValue, pyValue
	Variable Nz, Ny, pzErValue, pyErValue
	Variable IntegSx,IntegEx
	variable xstart, xdelta
	variable flag

	
	Do
	
		SrcMatname = $SrDataWN[ii]
		flag = cmpstr(SrcMatname,"")
//		print ii, SrcMatname
		
		if (flag==1)
			make/d/o/N=(dimsize ($SrcMatname,0)) temp1, temp2, temp3, temp4, temp5

			temp1=$SrcMatname[p][0]
			temp2=$SrcMatname[p][1]
			temp3=$SrcMatname[p][2]
			temp4=$SrcMatname[p][3]
			temp5=$SrcMatname[p][4]
	
			xstart = dimoffset ($SrcMatname,0)
			xdelta = dimdelta ($SrcMatname,0)
			SetScale/P x xstart, xdelta,"", temp1
			SetScale/P x xstart, xdelta,"", temp2
			SetScale/P x xstart, xdelta,"", temp3
			SetScale/P x xstart, xdelta,"", temp4
	
			duplicate/o temp1 temp1_nm, temp2_nm, temp3_nm, temp4_nm
			duplicate/o temp1 temp_Totz, temp_Toty
			duplicate/o temp1 temp_az, temp_ay, temp_pz, temp_py
			duplicate/o temp1 temp_Zup, temp_Zdn, temp_Yup, temp_Ydn
		
		
		
			SpinCalcForTemp()
			
		 	IntegSx = pnt2x (temp_pz, IntegS)
		 	IntegEx = pnt2x (temp_pz, IntegE)
		
			pzValue = sum(temp_pz,IntegSx, IntegEx)/ (IntegE-IntegS+1)
			pyValue = sum(temp_py,IntegSx, IntegEx)/ (IntegE-IntegS+1)

			$pzWN[ii] = pzValue
			$pyWN[ii] = pyValue
		
			
			Nz = sum(temp1,IntegSx, IntegEx) + sum(temp1,IntegSx, IntegEx)
			Ny = sum(temp3,IntegSx, IntegEx) + sum(temp4,IntegSx, IntegEx)

			$pzErWN[ii] = 1/0.035/sqrt(Nz)/2
			$pyErWN[ii] = 1/0.035/sqrt(Ny)/2
			
		endif
	
	
		
		if (flag==0)
			$pzWN[ii]=nan
			$pyWN[ii]=nan
			$pzErWN[ii] = nan
			$pyErWN[ii] = nan
			
		endif 
		
		
		ii=ii+1
	while (ii < endp)
	
	
	
	
	
Macro MatrixCombines(addPnts)
Variable addPnts=2

	PauseUpdate; Silent 1

	variable flag
	flag = cmpstr(MN_Mottmatrix,"")
	
	if (flag==1)
	make/d/o/N=(dimsize ($MN_Mottmatrix,0)) Ctemp1, Ctemp2, Ctemp3, Ctemp4, Ctemp5

	Ctemp1=$MN_Mottmatrix[p][0]
	Ctemp2=$MN_Mottmatrix[p][1]
	Ctemp3=$MN_Mottmatrix[p][2]
	Ctemp4=$MN_Mottmatrix[p][3]
	Ctemp5=$MN_Mottmatrix[p][4]
	
	variable xstart, xdelta, xsize, Cxsize, cxdelta
	xstart = dimoffset ($MN_Mottmatrix,0)
	xdelta = dimdelta ($MN_Mottmatrix,0)
	xsize = dimsize($MN_Mottmatrix,0)
	Cxsize =  ceil(xsize/addPnts)
	cxdelta = xdelta * addPnts
	SetScale/P x xstart, xdelta,"", Ctemp1
	SetScale/P x xstart, xdelta,"", Ctemp2
	SetScale/P x xstart, xdelta,"", Ctemp3
	SetScale/P x xstart, xdelta,"", Ctemp4
	
	//////////////  Make matrix /////////////
	String MN_con
	MN_con = "Con_" + MN_Mottmatrix
	Make/d/o/N=(Cxsize,5)/D $MN_con
	SetScale/P x xstart,cxdelta,"", $MN_con

	//////////  combine //////////////////
	string OWN, WN
	variable Wnum, Pnum
	Wnum=1
	Pnum =0
	variable ep,sp, v1
	
	Do
		OWN =  "Ctemp"+num2str(Wnum)
		WN = "Dtemp"+num2str(Wnum)		
		Make /d/o/N=(cxsize) $WN
		SetScale/P x 0,1,"", $OWN
		
		print OWN, "to", WN

		Pnum = 0
		Do
			sp = pnum * addPnts
			ep = sp + addPnts -1
			V1=Sum($OWN,SP,EP)
			
			$WN[Pnum] = V1
			Pnum = Pnum +1
		while (Pnum<(Cxsize+1))
		
		SetScale/P x xstart, xdelta,"", $OWN
		SetScale/P x xstart, cxdelta,"", $WN
				
		Wnum = Wnum +1
	
	while (Wnum<6)


	$MN_con[][0] = Dtemp1[p]
	$MN_con[][1] =Dtemp2[p]
	$MN_con[][2] = Dtemp3[p]
	$MN_con[][3] = Dtemp4[p]
	$MN_con[][4] = Dtemp5[p]

	
	endif

	
endmacro

Macro BGsubtraction(OrigMatN,CoefWaveN,flag1)
String OrigMatN, CoefWaveN
variable flag1

	make/d/o/N=(dimsize ($OrigMatN,0)) Ctemp1, Ctemp2, Ctemp3, Ctemp4, Ctemp5
	
	
	variable xstart, xdelta, xsize
	xstart = dimoffset ($OrigMatN,0)
	xdelta = dimdelta ($OrigMatN,0)
	xsize = dimsize($OrigMatN,0)
	SetScale/P x xstart, xdelta,"", Ctemp1
	SetScale/P x xstart, xdelta,"", Ctemp2
	SetScale/P x xstart, xdelta,"", Ctemp3
	SetScale/P x xstart, xdelta,"", Ctemp4
	
	
	
	duplicate/o Ctemp1  BGtry
	
	make/d/o/N=10 coef
	coef = $CoefWaveN
	
	BGtry= 1/((x-coef[1])^(coef[3])+(coef[2])^(coef[3]))*coef[0] * (1/(exp((x-coef[4])/coef[5])+1))


	Ctemp1=$OrigMatN[p][0]
	Ctemp2=$OrigMatN[p][1]
	Ctemp3=$OrigMatN[p][2]
	Ctemp4=$OrigMatN[p][3]
	
//	Ctemp1=Ctemp1* VG_InstAssy_z
//	Ctemp3=Ctemp3 * VG_InstAssy_y
	
	Ctemp1=Ctemp1-BGtry/VG_InstAssy_z
	Ctemp2=Ctemp2-BGtry
	Ctemp3=Ctemp3-BGtry/VG_InstAssy_y
	Ctemp4=Ctemp4-BGtry
	
	
	String BgsMatN
	
	BgsMatN = "Bgs_"+OrigMatN
	duplicate/o $OrigMatN $BgsMatN
	
	
	$BgsMatN[][0] = Ctemp1[p]
	$BgsMatN[][1] =Ctemp2[p]
	$BgsMatN[][2] = Ctemp3[p]
	$BgsMatN[][3] = Ctemp4[p]
	
	
	if (flag1==1)
	MakeTempWaves()
	 SpinCalcForTemp()
	endif
	
	
endmacro

Function SpinButtonProc_3(ctrlName) : ButtonControl
	String ctrlName
	
		Execute "Edit Info_base"
		Execute "AppendToTable Info_data"
		Execute "AppendToTable Info_info"
		Execute "AppendToTable Info_Epass,Info_GlobalFlag,Info_sher,Info_offset,Info_instAy;DelayUpdate"
		Execute "AppendToTable Info_instAz,Info_Bg_y, Info_BG_z "


End




Function SpinMatMaking(startP,endP,AreaInt, grobalSher, grobalInstAy, grobalInstAz)
Variable startP,endP,AreaInt, grobalSher, grobalInstAy, grobalInstAz

	wave/T Info_data
	wave info_instAy,  info_instAz
	wave info_Bg_y,  info_Bg_z
	wave info_sher

	duplicate/o info_instAy Info_AreaInt
	
	/// Set up waves and matrix
	String matN
	matN = Info_data[0]
	
	Variable xsize, xstart, xstep     /////waves
	xsize = dimsize($matN,0)
	xstart = dimoffset($matN,0)
	xstep = dimdelta($matN,0)
	Make/N=(xsize)/O  w1, w2, w3, w4, wt, pyt, pzt, syDt, syUt, szDt, szUt 
	Variable ysize, ii=0			////// Matrix
	Do
		ii +=1
	while ( cmpstr( Info_data[ii],"")==1)
	ysize =ii
	Make/N=(xsize,ysize)/D/O Tmap
	SetScale/P x xstart,xstep,"", Tmap
	duplicate/O Tmap  SyUmap, SyDmap, Pymap,SzUmap, SzDmap, Pzmap

 	ii=0
	Variable areaI
	Do
		matN = Info_data[ii]
		duplicate/o $matN mat1
		w1 = mat1[p][0]
		w2 = mat1[p][1]
		w3 = mat1[p][2]
		w4 = mat1[p][3]
		wt = w1 + w2 + w3 + w4
		areaI= sum(wt, startP, endP)
		w2 = w2 -  info_Bg_z[ii]    /////////   BG correction
		w4 = w4 -  info_Bg_y[ii]
		w1 = w1/ areaI * AreaInt   //////////  Normarize for different angle
		w2 = w2/ areaI * AreaInt
		w3 = w3/ areaI * AreaInt
		w4 = w4/ areaI * AreaInt
		
		if (grobalInstAz==0)  //////////  Normarize for spin analysis of z
			w1 = w1 *   info_instAz[ii]
		else
			w1 = w1 * grobalInstAz
		endif
		
		if (grobalInstAy==0) //////////  Normarize for spin analysis of y
			w3 = w3 *   info_instAy[ii]
		else
			w3 = w3 * grobalInstAy
		endif

		if (grobalSher==0) //////////  Calculation of  polarizaion
			pzt = (w2-w1)/(w1+w2)/info_sher[ii]
			pyt = (w4-w3)/(w3+w4)/info_sher[ii]
		else
			pzt = (w2-w1)/(w1+w2)/grobalSher
			pyt = (w4-w3)/(w3+w4)/grobalSher	
		endif
		
		 syUt = (w3+w4) * (1+pyt)/2  /////////////Calculation of  spin-resolved
		 syDt = (w3+w4) * (1-pyt)/2
		 szUt = (w1+w2) * (1+pzt)/2
		 szDt = (w1+w2) * (1-pzt)/2		
		 
		Tmap[][ii] = w1[p]+w2[p]+w3[p]+w4[p]
		Pymap[][ii] = pyt[p]
		Pzmap[][ii] = pzt[p]
		SyUmap[][ii] = syUt[p]
		SyDmap[][ii] = syDt[p]
		SzUmap[][ii] = szUt[p]
		SzDmap[][ii] = szDt[p]
		
		
		ii +=1
	while ( cmpstr( Info_data[ii],"")==1)
	
	killwaves  w1, w2, w3, w4, wt, pyt, pzt, syDt, syUt, szDt, szUt 
	
End


Function SpinSetVarProc_1(ctrlName,varNum,varStr,varName) : SetVariableControl
	String ctrlName
	Variable varNum
	String varStr
	String varName
	
	Spin_SetAnalysisWaves()
	Execute "LocalParemeterUPdate()"
	
	String/G SG_Mtname
	Variable/G VG_MN_SavedResults
	if ( cmpstr( SG_Mtname,"")==1)
		SpinCalcLocal(VG_MN_SavedResults)
	endif

End

Function SpinButtonProc_9(ctrlName) : ButtonControl
	String ctrlName
	
	UpdateSaveResluts()

End


Function SpinCheckProc_2(ctrlName,checked) : CheckBoxControl
	String ctrlName
	Variable checked
	
	Variable/G FlagVG_TableChoice
	
	CheckBox check4,value=0
	CheckBox check5,value= 0
	CheckBox check6,value= 0
	
	strswitch (ctrlName) 
		case "check4":
		FlagVG_TableChoice= 1
		CheckBox check4,value=1
		SpinMatrixListIndex()
		SpinMatrixNamePickUP()
		MakeTempWaves()
		SpinCalcForTemp()
		break
		case "check5":
		FlagVG_TableChoice= 2
		CheckBox check5,value=1
		SpinMatrixListIndex()
		SpinMatrixNamePickUP()
			MakeTempWaves()
		SpinCalcForTemp()
		break
		
		case "check6":
		FlagVG_TableChoice= 3
		CheckBox check6,value=1
		SpinMatrixListIndex()
		SpinMatrixNamePickUP()
		MakeTempWaves()
		SpinCalcForTemp()
		break
	endswitch

End


Function Spin_setvar_setdataNum(ctrlName,varNum,varStr,varName) : SetVariableControl
	String ctrlName
	Variable varNum
	String varStr
	String varName
	
	DFREF dfr = root:SpinAnalysis

	SVAR  WN_matrix = dfr:WN_matrix
	NVAR  FlagVG_TempSaved = dfr:FlagVG_TempSaved
	
	SpinMatrixListIndex()
		
	String  MN
	variable flagS
	wave/T MottMTList = dfr:MottMTList
	NVAR VG_MN_Mottmatrix = dfr:VG_MN_Mottmatrix
	SVAR MN_Mottmatrix = dfr:MN_Mottmatrix
	
	if (varNum >=0)
	MN = MottMTList[VG_MN_Mottmatrix]
	flagS = cmpstr(MN,"")
	endif
	
	if (flagS!=0)
		 MN_Mottmatrix = MN
		 
		 MakeTempWaves()
		 
		 SpinCalcForTemp()
		 
	elseif (flagS==0)
	
		MN_Mottmatrix = ""
		 
	endif

	
	
End


Function SP_button_done(ctrlName) : ButtonControl
	String ctrlName

	Dowindow/K SpinPanel
	
End


Function Spin_setvar_SetMatName(ctrlName,varNum,varStr,varName) : SetVariableControl
	String ctrlName
	Variable varNum
	String varStr
	String varName
	
	
	DFREF dfr = root:SpinAnalysis

	SVAR  WN_matrix = dfr:WN_matrix
	NVAR  FlagVG_TempSaved = dfr:FlagVG_TempSaved
			
	variable flagS
	SVAR MN_Mottmatrix = dfr:MN_Mottmatrix
	flagS = exists(varStr)
	
	if (flagS!=0)
		 MN_Mottmatrix = varStr
		 
		 MakeTempWaves()
		 
		 SpinCalcForTemp()
		 
	elseif (flagS==0)
	
		print "such matrix does not exsit"
		 
	endif


End
