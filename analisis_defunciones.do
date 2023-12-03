*use "D:\Maestrias\USanAndres\3er Trim\Seminario de tesis\suicidios\data_work_suicides.dta", clear
use "D:\Maestrias\USanAndres\3er Trim\Seminario de tesis\suicidios\data_work_suicides_SR.dta", clear

sort FECHA CODUBIGEODOMICILIO DISTRITODOMICILIO

format %td FECHA
gen FECHA_s=string(year(FECHA))+"/"+string(month(FECHA))+"/"+string(day(FECHA))

gen month=ym(year(FECHA),month(FECHA))
format %tm month
*decode month, gen(month1)
gen month_s=string(year(FECHA))+"/"+string(month(FECHA))
gen year=year(FECHA)

gen week=wofd(FECHA) if year==2017
replace week=wofd(FECHA) if year==2018
format %tw week

gen muerte=1

replace MUERTEVIOLENTA="SUICIDIO" if  MUERTEVIOLENTA=="INTENTO SUICIDA"

encode DEPARTAMENTODOMICILIO, gen(departamento)
encode PROVINCIADOMICILIO, gen(provincia)
encode DISTRITODOMICILIO, gen(distrito)
*graph hbar muerte, over(MUERTEVIOLENTA) over(year)
*keep if FECHA>=td("01jan2019") & FECHA<=td("31dec2019")
collapse (sum) suicidio intoxicacion asfixia_ahogamiento homicidio arma accidente_transito accidente_trabajo otro_accidente, by(year) //provincia month month_s | year FECHA FECHA_s  MUERTEVIOLENTA DEPARTAMENTODOMICILIO month1 FECHA
/*
gen atleast_1suicide=suicidio>=1
lab def atleast_1suicide 1"At least 1 suicide" 0"No suicides"
lab value atleast_1suicide atleast_1suicide
graph bar if year==2019, over(atleast_1suicide) graphregion(color(white)) scale(.65) intensity(40) ylabel(0(20)100)  bar(1, color(gray)) 
graph export "D:\Maestrias\USanAndres\3er Trim\Seminario de tesis\suicidios\suicidios_distritos_2019.png", replace
*/
gen dias=_n
gen meses=_n

foreach i in suicidio intoxicacion asfixia_ahogamiento homicidio arma accidente_transito accidente_trabajo otro_accidente {
    gen `i'_rate = .
}

*
* Generate a new variable "order" representing the order of departments
egen order = group(year)

local population 30973992 31562130 32131400 32625948 33715471

foreach i in suicidio intoxicacion asfixia_ahogamiento homicidio arma accidente_transito accidente_trabajo otro_accidente {
    forvalues j = 1/5 {
        replace `i'_rate = (`i' / `: word `j' of `population'') * 100000 if order == `j'
    }
}

foreach i in suicidio intoxicacion asfixia_ahogamiento homicidio arma accidente_transito accidente_trabajo otro_accidente {
	gen `i'_mva=(`i'[_n-6]+`i'[_n-5]+`i'[_n-4]+`i'[_n-3]+`i'[_n-2]+`i'[_n-1]+`i')/7
}
*/
global y_r suicidio_rate intoxicacion_rate asfixia_ahogamiento_rate homicidio_rate arma_rate accidente_transito_rate accidente_trabajo_rate otro_accidente_rate
global y suicidio intoxicacion asfixia_ahogamiento homicidio arma accidente_transito accidente_trabajo otro_accidente

*sort FECHA
*
graph bar $y_r if year<2021, over(year) graphregion(color(white)) scale(.65) intensity(40) bar(1, color(black)) ///
	legend(order(1 "Suicides rate" 2 "Poisoning suicides rate" 3 "Asphyxia suicides rate" ///
				4 "Homicides rate" 5 "Weapon homicides rate" 6 "Transit accident death rate" ///
				7 "Work accident death rate" 8 "Other accident death rate") col(3))
graph export "D:\Maestrias\USanAndres\3er Trim\Seminario de tesis\suicidios\tipo_muertesviolentas_year.png", replace
e
*/
/*
twoway lpoly suicidio_rate meses if year<2020, lcolor(red) || ///
	lpoly intoxicacion_rate meses if year<2020, lcolor(cranberry) || ///
	lpoly asfixia_ahogamiento_rate meses if year<2020, lcolor(cyan) || ///
	lpoly homicidio_rate meses if year<2020, lcolor(dkorange) || ///
	lpoly arma_rate meses if year<2020, lcolor(bluishgray) || ///
	lpoly accidente_transito_rate meses if year<2020, lcolor(lavender) || ///
	lpoly accidente_trabajo_rate meses if year<2020, lcolor(magenta) || ///
	lpoly otro_accidente_rate meses if year<2020, lcolor(navy) || ///
	scatter suicidio_rate meses if year<2020, mcolor(red) || ///
	scatter intoxicacion_rate meses if year<2020, mcolor(cranberry) || ///
	scatter asfixia_ahogamiento_rate meses if year<2020, mcolor(cyan) || ///
	scatter homicidio_rate meses if year<2020, mcolor(dkorange) || ///
	scatter arma_rate meses if year<2020, mcolor(bluishgray) || ///
	scatter accidente_transito_rate meses if year<2020, mcolor(lavender) || ///
	scatter accidente_trabajo_rate meses if year<2020, mcolor(magenta) || ///
	scatter otro_accidente_rate meses if year<2020, mcolor(navy) graphregion(color(white)) scale(.65) legend(order(1 "Tasa de suicidios" ///
				2 "Tasa de suicidios por intoxicación" 3 "Tasa de suicidios por asfixia" ///
				4 "Tasa de homicidios" 5 "Tasa de homicidios por armas" 6 "Tasa de accidentes de transito" ///
				7 "Tasa de accidentes en el trabajo" 8 "Tasa de otros accidentes") col(3)) xlabel(0(5)35) xline(4 16 28, lpatter(dash)) ///
	text(.78 5 "Abril 2017") text(.78 17 "Abril 2018") text(.78 29 "Abril 2019")
e
*/
*
twoway lpoly suicidio_rate dias if year<2020 & dias>=807 & dias<=867, lcolor(red) || ///
	scatter suicidio_rate dias if year<2020 & dias>=807 & dias<=867, mcolor(red) graphregion(color(white)) scale(.45) ///
	 xlabel(807(5)867) xline(837 107 472, lpatter(dash)) legend(order(1 "Tasa de suicidio diario")) ///
	 text(.023 100 "17 Abril 2017") text(.023 480 "17 Abril 2018") text(.023 840 "17 Abril 2019")
*/
/*
twoway lpoly suicidio_rate dias if year<2020, lcolor(red) || ///
	scatter suicidio_rate dias if year<2020, mcolor(red) graphregion(color(white)) scale(.45) ///
	 xlabel(0(100)1100) xline(837 107 472, lpatter(dash)) legend(order(1 "Tasa de suicidio diario")) ///
	 text(.023 100 "17 Abril 2017") text(.023 480 "17 Abril 2018") text(.023 830 "17 Abril 2019")
*/
e
/* Generate a new variable "order" representing the order of departments
egen order = group(departamento)

*2017
local population 425000 1160500 462800 1315500 703700 1537200 1038700 1331800

foreach i in suicidio intoxicacion asfixia_ahogamiento homicidio arma accidente_transito accidente_trabajo otro_accidente {
    forvalues j = 1/8 {
        replace `i'_rate = (`i' / `: word `j' of `population'') * 100000 if order == `j' & year==2017
    }
}

local population 502100 872500 802600 1370200 1905300 1280700 10143000 1059000 ///
	143700 184200 308500 1873000 1442900 862800 350100 243300 506900
foreach i in suicidio intoxicacion asfixia_ahogamiento homicidio arma accidente_transito accidente_trabajo otro_accidente {
    forvalues j = 1/17 {
        replace `i'_rate = (`i' / `: word `j' of `population'') * 100000 if order == `j'+ 9 & year==2017
    }
}
*
*2018
local population 425800 1166200 464600 1329800 711100 1540000 1053000 1338900

foreach i in suicidio intoxicacion asfixia_ahogamiento homicidio arma accidente_transito accidente_trabajo otro_accidente {
    forvalues j = 1/8 {
        replace `i'_rate = (`i' / `: word `j' of `population'') * 100000 if order == `j' & year==2018
    }
}

local population 505000 878200 810200 1379900 1928200 1290600 10982000 1068100 ///
	146900 186000 310600 1887200 1457000 873600 354200 246000 512400

foreach i in suicidio intoxicacion asfixia_ahogamiento homicidio arma accidente_transito accidente_trabajo otro_accidente {
    forvalues j = 1/17 {
        replace `i'_rate = (`i' / `: word `j' of `population'') * 100000 if order == `j'+ 9 & year==2018
    }
}

*2019
local population 419300 1193400 447700 1525900 680800 1480900 1100400 1336000

foreach i in suicidio intoxicacion asfixia_ahogamiento homicidio arma accidente_transito accidente_trabajo otro_accidente {
    forvalues j = 1/8 {
        replace `i'_rate = (`i' / `: word `j' of `population'') * 100000 if order == `j' & year==2019
    }
}

local population 383200 799000 940400 1378900 1965600 1321700 10491000 980200 ///
	 157400 192600 282100 2053900 1296500 902800 364700 249100 552000

foreach i in suicidio intoxicacion asfixia_ahogamiento homicidio arma accidente_transito accidente_trabajo otro_accidente {
    forvalues j = 1/17 {
        replace `i'_rate = (`i' / `: word `j' of `population'') * 100000 if order == `j'+ 9 & year==2019
    }
}
*

*2020
local population 426806 1180638 430736 1497438 668213 1453711 1129854 1357075

foreach i in suicidio intoxicacion asfixia_ahogamiento homicidio arma accidente_transito accidente_trabajo otro_accidente {
    forvalues j = 1/8 {
        replace `i'_rate = (`i' / `: word `j' of `population'') * 100000 if order == `j' & year==2020
    }
}

local population 365317 760267 975182 1361467 2016771 1310785 10628470 1027559 ///
	 173811 192740 271904 2047954 1237997 899648 370974 251521 589110

foreach i in suicidio intoxicacion asfixia_ahogamiento homicidio arma accidente_transito accidente_trabajo otro_accidente {
    forvalues j = 1/17 {
        replace `i'_rate = (`i' / `: word `j' of `population'') * 100000 if order == `j'+ 9 & year==2020
    }
}
*/

bys year departamento: egen suicidio_rate_mean=mean(suicidio_rate)

/*ANUAL DEPARTAMENTAL
*graph hbar suicidio_rate if year<2020 & departamento!=9, over(departamento, sort(suicidio_rate)) over(year) graphregion(color(white)) scale(.35) intensity(40) ytitle("")
*/
/*MENSUAL DEPARTAMENTAL
*graph hbar suicidio_rate if year==2019 & departamento==4, over(month_s, sort(month)) over(departamento) graphregion(color(white)) scale(.6) intensity(40) ytitle("")


graph box suicidio_rate if year==2019 & departamento!=9, over(departamento, sort(suicidio_rate) label(angle(90))) ///
	graphregion(color(white)) scale(.6) intensity(30) ytitle("")
	*/

*DIARIO DEPARTAMENTAL

graph box suicidio_rate if year==2017 & departamento!=9, over(departamento, sort(suicidio_rate_mean) label(angle(90))) ///
	graphregion(color(white)) scale(.6) intensity(30) ytitle("")
