#pragma rtGlobals=1		// Use modern global access method.


Macro SetUpSort3D()
	// EditAngle関係
	Variable/G GV_editSN=0
	Variable/G GV_editEN=10
	
	//Sorting関係
	String/G  GS_imagetableName="image_table"
	
	variable size
	if (waveexists(info_wave)==1)
	size = dimsize(info_wave,0)
	GV_editSN=0
	GV_editEN=size
	endif
	
	SetEditTable()
	
	PauseUpdate; Silent 1		// building window...
	NewPanel /W=(824,123,932,254)/N=SortFor3Dmap
	ModifyPanel cbRGB=(65535,49151,55704)
	Button button0,pos={10,6},size={83,20},proc=SortFor3D_ButtonProc_0,title="edit angle"
	Button button1,pos={10,29},size={83,20},proc=SortFor3D_ButtonProc_1,title="omit data"
	Button button2,pos={10,51},size={83,20},proc=SortFor3D_ButtonProc_2,title="Make ImgTbl"
	SetVariable setvar0,pos={7,76},size={47,15},title="s",value= GV_editSN
	SetVariable setvar1,pos={51,76},size={48,15},title="e",value= GV_editEN
	Button button3,pos={54,95},size={38,20},proc=SortFor3D_ButtonProc_3,title="done"
	Button button3,fColor=(65535,16385,16385)
	Button button4,pos={12,95},size={35,20},proc=SortFor3D_ButtonProc_4,title="list"
	
	
endmacro


Function SetEditTable()

	variable size
	if (waveexists(info_wave)==1)
		size = dimsize(info_wave,0)
	endif
	
	if (waveexists(angle)==1)
		Redimension/N=(size) Angle
	else
		make/N=(size) angle
	endif
	
	if (waveexists(memo)==1)
		Redimension/N=(size) memo
	else
		make/N=(size)/T memo
	endif
		
	if (waveexists(omitw)==1)
		Redimension/N=(size) omitw
	else
		make/N=(size)  omitw
	endif
	
	if (waveexists(x_base)==1)
		Redimension/N=(size) x_base
	else
		make/N=(size)/T x_base
	endif
	
	if (waveexists(y_base)==1)
		Redimension/N=(size) y_base
	else
		make/N=(size)/T y_base
	endif
		
	if (waveexists(x_start_wave)==1)
		Redimension/N=(size) x_start_wave
	else
		make/N=(size)  x_start_wave
	endif
	
	if (waveexists(start_wave)==1)
		Redimension/N=(size) start_wave
	else
		make/N=(size)  start_wave
	endif
	
	if (waveexists(last_wave)==1)
		Redimension/N=(size) last_wave
	else
		make/N=(size)  last_wave
	endif
	
	if (waveexists(offset_wave)==1)
		Redimension/N=(size) offset_wave
	else
		make/N=(size)  offset_wave
	endif
	
	if (waveexists(bias_wave)==1)
		Redimension/N=(size) bias_wave
	else
		make/N=(size)  bias_wave
	endif
	
	
	Dowindow AngleList
	if (V_flag==0)
		edit/N=AngleList/W=(5,44,288,836)  Info_wave, angle,omitw, memo
		ModifyTable width(Angle)=50
		ModifyTable width(omitw)=30
	endif
	Dowindow/F AngleList

End



Function EnterAngle()
PauseUpdate; Silent 1

	
	wave/T Info_wave, memo
	wave angle


	Dowindow AngleList
	if (V_flag==0)
		edit/N=AngleList/W=(5,44,288,836)  Info_wave, angle, memo
	endif
	
	Dowindow/F AngleList
	
	
		variable yesno3
		variable sn1=0,en1=20
		variable Astep1=1,Sangle=0
		variable pnum
				
			Prompt sn1, "start number of Info_wave to enter angle"
			Prompt en1, "end number of Info_wave to enter angle"
			Doprompt "Select cell number", sn1, en1
			modifytable /W=anglelist topleftcell=(sn1-5,0)
			if (V_Flag)
				return -1
			endif
			
			Prompt Sangle, "Angle of start cell" + num2str(sn1)
			Prompt Astep1, "angle step"
			Doprompt "AngleSet" Sangle, Astep1
			if (V_Flag)
				return -1
			endif
			
			pnum = sn1
			Do 
				angle[pnum] = Sangle+(pnum-sn1)*Astep1
				pnum+=1
			while(pnum<(en1+1))
			
			Doupdate

		
end





/////////////  edit angle ////////////////////////////////////////
Function SortFor3D_ButtonProc_0(ctrlName) : ButtonControl
	String ctrlName
	
	Dowindow AngleList
	if (V_flag==0)
		SetEditTable()
	endif
	Dowindow/F AngleList
	Doupdate
	
	EnterAngle()

End

/////////////  omit angle ////////////////////////////////////////
Function SortFor3D_ButtonProc_1(ctrlName) : ButtonControl
	String ctrlName
	
	Dowindow AngleList
	if (V_flag==0)
		SetEditTable()
	endif
	Dowindow/F AngleList
	Doupdate
	
	OmitData()

End


Function OmitData()

	String  omitnum
	Variable flag
	Prompt flag, "Do you want to omit or inculde again ?", popup, "omit;recover" 
	Prompt omitnum, "enter the data num (e.g.  2,  3-10, 4-, -50)"
	Doprompt "Omit data", flag, omitnum
	
	if (V_Flag)
		return -1
	endif
	
	wave omitw
	
	variable size
	if (waveexists(info_wave)==1)
		size = dimsize(info_wave,0)
	endif
	
	variable pn, sn=0, en=size-1, cn
	variable cond1, cond2, cond3,cond4
	String numlist, snc,enc
	
	cond1 = grepstring(omitnum,"[^0-9]")
	if (cond1==0)
		pn=str2num(omitnum)
		
		switch(flag)
			case 1:
				omitw[pn]=1
				break
			case 2:
				omitw[pn]=0
				break
		endswitch
	endif
	
	cond2 = grepstring(omitnum,"[0-9]-[0-9]")
	if (cond2==1)
		numlist = replacestring ("-", omitnum, ";")
		snc = stringfromlist (0, numlist)
		enc = stringfromlist (1, numlist)
		sn = str2num(snc)
		en = str2num(enc)
		if (sn>en)
			cn=sn
			sn = en
			en = cn
		endif
		
		pn=sn
		Do
			switch(flag)
			case 1:
				omitw[pn]=1
				break
			case 2:
				omitw[pn]=0
				break
			endswitch			
			pn+=1
		while (pn<en+1)	
	endif
	
	cond3 = grepstring(omitnum,"[0-9]-(| +)\Z")
	if (cond3==1)
		numlist = replacestring ("-", omitnum, ";")
		snc = stringfromlist (0, numlist)
		sn = str2num(snc)
		en = size-1

		pn=sn	
		Do
			switch(flag)
			case 1:
				omitw[pn]=1
				break
			case 2:
				omitw[pn]=0
				break
			endswitch			
			pn+=1
		while (pn<en+1)
	endif

	cond4 = grepstring(omitnum,"\A-[0-9+]")
	if (cond4==1)
		numlist = replacestring ("-", omitnum, ";")
		enc = stringfromlist (1, numlist)
		sn= 0
		en = str2num(enc)
		pn=sn	
		Do
			switch(flag)
			case 1:
				omitw[pn]=1
				break
			case 2:
				omitw[pn]=0
				break
			endswitch			
			pn+=1
		while (pn<en+1)
	endif
End

///////////////////  Sorting angle  //////////////////////////
Function SortFor3D_ButtonProc_2(ctrlName) : ButtonControl
	String ctrlName
	
	String/G  GS_imagetableName
	String iname="image_table"
	Prompt iname, "Enter the name of image_table"
	Doprompt "Image_table",iname
	if (V_Flag)
		return -1
	endif
	
	if (grepstring(iname, "\Aimage_table")==1)
		GS_imagetableName = iname
	else
		return -1
	endif
	
	
	Dowindow AngleList
	if (V_flag==0)
		SetEditTable()
	endif
	Dowindow/F AngleList
	Doupdate
	
	 SortingAngle()

End



Function SortingAngle()
PauseUpdate; Silent 1	
	////////////////  angle, info_wave, memo の中から ///////////////////////
	////////////////  info_waveに情報の無いcellを抜いて //////////////////////
	////////////////  各waveを再構成 ////////////////////////////////////////
	Variable/G GV_editSN
	Variable/G GV_editEN
	String/G  GS_imagetableName
	wave angle
	wave omitw
	wave/T info_wave
	variable sn,en
	variable pn, pend, resize
	variable ov,an, ix
	variable condf
	String info0
	
	sn = GV_editSN
	en = GV_editEN
	
	wave angle_o
	wave omitw_o
	wave index_o
	duplicate/o angle angle_o
	duplicate/o angle index_o	
	
	angle_o=0
	index_o=0
	
	ix = sn
	pn=0
	resize=en-sn+1
	Do
		an = angle[ix]
		ov = omitw[ix]
		info0 = info_wave[ix]
		condf = cmpstr(info0, "")
		
		if (ov==0 && condf !=0)	
			angle_o[pn] = an
			index_o[pn] = ix
			pn+=1
		else
			resize-=1
		endif
		ix+=1
	while(ix<(en+1))

	
	Redimension/N=(resize) angle_o
	Redimension/N=(resize) index_o
	
	
	
	
	//////////////////////////////////////////////////////////////////////////
	///////////////  step 数、降順か昇順か、空白判定値を入力  ////////////////
	Variable Astep3D=1, indec=1, SpaceGap=2
	Prompt Astep3D, "angle step for 3Dmatrix or imagetable"
	Prompt indec, "In which way do you sort ?", popup, "increase;decrease"
	Prompt SpaceGap, "Space gap Factor? (Spacegap = SpaceGapFactor  * astep3D)"
	Doprompt "Sorting", Astep3D,indec , SpaceGap
	
	if (V_Flag || Astep3D<0)
	return -1
	endif
	
	////////////////////////////////////////////////////////
	//////////////  angle の中で最小値、最大値を検索 ////////

	variable Maxangle, Minangle
	
	Maxangle =  wavemax(angle_o)
	Minangle =  wavemin(angle_o)
	
	
	//////////////  step数と最大値、最小値から大きい  /////////////////
	/////////////  サイズの image_table, info_ref,angle_ref, (hybr_ref)を作成/////
	Variable  newstep
	Variable newwavesize
	newstep = Astep3D
	newwavesize =round((Maxangle-Minangle)/Astep3D )+1
	
	wave angle_sort, hybr_sort, it1
	make/O/N=(newwavesize)  angle_sort
	duplicate/o angle_o angle_dis
//	make/O/N=(newwavesize)  hybr_sort
	make/O/N=(newwavesize)  it1
	String command = "make/N=" + num2str(newwavesize) +  "/T/O  info_sort"
	Execute command
	wave/T info_sort

	
	angle_sort = Minangle + p*newstep
	 info_sort =""

 	///////////   Sorting Routine    ////////////////////////////
 	Variable ii=0
 	Variable ca1, pb1, ca2, pb2
 	Variable cond1,cond2
 	String info1
 	
 		Do
 		///////// ii 回目 /////////////////
 		//////////////angle_ref(ii)に最も近いangleとそのp点を割り出す ////////////
 			ca1 = angle_sort(ii)
			angle_dis = angle_o - ca1
			angle_dis = sqrt(angle_dis^2)
 			wavestats/Q angle_dis
 			pb1 = x2pnt(angle_dis, V_minloc)
 			pb2 = index_o[pb1]
			info1 = Info_wave[pb2]
			ca2 = angle_o[pb1]
			
			cond1 = abs(ca2-ca1) < (SpaceGap*astep3D)
			
			if (cond1)
 				it1[ii] = pb2
 				info_sort[ii] = info1
 			else
 				it1[ii]=nan
 				info_sort[ii] = ""
 			endif		

 		      ii+=1
 		while(ii<(newwavesize+1))
 		
 		 		
 		if (indec==2)
 			reverse it1
 			reverse angle_sort
			ii=0
			Do
				pb1=it1[ii]
				info1 = Info_wave[pb1]
				info_sort[ii] = info1
				ii+=1
			while(ii<(newwavesize+1))
 		endif

	String iname, anglename, infoname
	String suffix,fc,ss1
	variable sl,conds
	sl = strlen(GS_imagetableName)
	ss1 = GS_imagetableName[11,sl]
	fc = ss1[0]
	conds = cmpstr(fc,"_")
	if (conds==0)
		ss1 = GS_imagetableName[12,sl]
	endif
	suffix = ss1
	
	iname =  GS_imagetableName
	anglename = "angle_"+suffix
	infoname = "info_"+suffix
	
	duplicate/o  it1 $iname
	duplicate/o  info_sort $infoname
	duplicate/o  angle_sort $anglename
	
	String windowName 
	windowName = "ImageTable_"+suffix+ "_List"
	
	Dowindow $windowName
	if (V_flag==0)
		edit/W=(300,44,560,700)/N=$windowName $iname, $anglename, $infoname
		ModifyTable width($iname)=50
		ModifyTable width($anglename)=50
		ModifyTable width($infoname)=60
	endif
	Dowindow/F $windowName

end



///////////////////  Close SortFor3Dmap window  //////////////////////////
Function SortFor3D_ButtonProc_3(ctrlName) : ButtonControl
	String ctrlName
	
	Dowindow/K SortFor3Dmap
	
	Dowindow AngleList
	if (V_flag==1)
	Dowindow/K AngleList
	endif
	
	

End



///////////////////  Showing List  //////////////////////////
Function SortFor3D_ButtonProc_4(ctrlName) : ButtonControl
	String ctrlName
	
	String ImageTableList
	ImageTableList =  wavelist("image*", ";","DIMS:1")
	
	String iname
	Prompt iname, "Chose image_table for check", popup, ImageTableList
	Doprompt "Check image_table, angle, and info_wave", iname
	
	String aname, infoname
	String suffix,fc,ss1
	variable sl,conds
	sl = strlen(iname)
	ss1 = iname[11,sl]
	fc = ss1[0]
	conds = cmpstr(fc,"_")
	if (conds==0)
		ss1 = iname[12,sl]
	endif
	suffix = ss1
	
	aname = "angle_"+suffix
	infoname = "info_"+suffix
	
	String windowName 
	windowName = "ImageTable_"+suffix+ "_List"
	
	Dowindow $windowName
	if (V_flag==0)
		edit/W=(300,44,560,700) $iname, $aname, $infoname
		ModifyTable width($iname)=50
		ModifyTable width($aname)=50
		ModifyTable width($infoname)=60
	endif
	Dowindow/F  $windowName
		
End

