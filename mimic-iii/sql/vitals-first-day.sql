-- This query pivots the vital signs for the first 24 hours of a patient's stay
-- Vital signs include heart rate, blood pressure, respiration rate, and temperature

DROP TABLE IF EXISTS gossis_vitals_d1 CASCADE;
create TABLE gossis_vitals_d1 as
SELECT pvt.subject_id, pvt.hadm_id, pvt.icustay_id
-- Easier names
, min(case when VitalID = 1 then valuenum else null end) as HeartRate_Min
, max(case when VitalID = 1 then valuenum else null end) as HeartRate_Max
, avg(case when VitalID = 1 then valuenum else null end) as HeartRate_Mean
, min(case when VitalID in (9,11) then valuenum else null end) as SysBP_Min
, max(case when VitalID in (9,11) then valuenum else null end) as SysBP_Max
, avg(case when VitalID in (9,11) then valuenum else null end) as SysBP_Mean
, min(case when VitalID in (10,12) then valuenum else null end) as DiasBP_Min
, max(case when VitalID in (10,12) then valuenum else null end) as DiasBP_Max
, avg(case when VitalID in (10,12) then valuenum else null end) as DiasBP_Mean
, min(case when VitalID in (13,14) then valuenum else null end) as MeanBP_Min
, max(case when VitalID in (13,14) then valuenum else null end) as MeanBP_Max
, avg(case when VitalID in (13,14) then valuenum else null end) as MeanBP_Mean
, min(case when VitalID = 5 then valuenum else null end) as RespRate_Min
, max(case when VitalID = 5 then valuenum else null end) as RespRate_Max
, avg(case when VitalID = 5 then valuenum else null end) as RespRate_Mean
, min(case when VitalID = 6 then valuenum else null end) as TempC_Min
, max(case when VitalID = 6 then valuenum else null end) as TempC_Max
, avg(case when VitalID = 6 then valuenum else null end) as TempC_Mean
, min(case when VitalID = 7 then valuenum else null end) as SpO2_Min
, max(case when VitalID = 7 then valuenum else null end) as SpO2_Max
, avg(case when VitalID = 7 then valuenum else null end) as SpO2_Mean
, min(case when VitalID = 8 then valuenum else null end) as Glucose_Min
, max(case when VitalID = 8 then valuenum else null end) as Glucose_Max
, avg(case when VitalID = 8 then valuenum else null end) as Glucose_Mean
, min(case when VitalID = 9 then valuenum else null end) as SysBPInv_Min
, max(case when VitalID = 9 then valuenum else null end) as SysBPInv_Max
, avg(case when VitalID = 9 then valuenum else null end) as SysBPInv_Mean
, min(case when VitalID = 10 then valuenum else null end) as DiasBPInv_Min
, max(case when VitalID = 10 then valuenum else null end) as DiasBPInv_Max
, avg(case when VitalID = 10 then valuenum else null end) as DiasBPInv_Mean
, min(case when VitalID = 11 then valuenum else null end) as SysBPNI_Min
, max(case when VitalID = 11 then valuenum else null end) as SysBPNI_Max
, avg(case when VitalID = 11 then valuenum else null end) as SysBPNI_Mean
, min(case when VitalID = 12 then valuenum else null end) as DiasBPNI_Min
, max(case when VitalID = 12 then valuenum else null end) as DiasBPNI_Max
, avg(case when VitalID = 12 then valuenum else null end) as DiasBPNI_Mean
, min(case when VitalID = 13 then valuenum else null end) as MBPInv_Min
, max(case when VitalID = 13 then valuenum else null end) as MBPInv_Max
, avg(case when VitalID = 13 then valuenum else null end) as MBPInv_Mean
, min(case when VitalID = 14 then valuenum else null end) as MBPNI_Min
, max(case when VitalID = 14 then valuenum else null end) as MBPNI_Max
, avg(case when VitalID = 14 then valuenum else null end) as MBPNI_Mean
, min(case when VitalID = 15 then valuenum else null end) as PASys_Min
, max(case when VitalID = 15 then valuenum else null end) as PASys_Max
, avg(case when VitalID = 15 then valuenum else null end) as PASys_Mean
, min(case when VitalID = 16 then valuenum else null end) as PADias_Min
, max(case when VitalID = 16 then valuenum else null end) as PADias_Max
, avg(case when VitalID = 16 then valuenum else null end) as PADias_Mean
, min(case when VitalID = 17 then valuenum else null end) as PAMean_Min
, max(case when VitalID = 17 then valuenum else null end) as PAMean_Max
, avg(case when VitalID = 17 then valuenum else null end) as PAMean_Mean

FROM  (
  select ie.subject_id, ie.hadm_id, ie.icustay_id
  , case
    when itemid in (211,220045) and valuenum > 0 and valuenum < 300 then 1 -- HeartRate
    -- below case statements just shown for illustration of getting any BP meas
    -- including them would supercede the non-invasive/invasive case statements
    -- when itemid in (51,442,455,6701,220179,220050) and valuenum > 0 and valuenum < 400 then 2 -- SysBP
    -- when itemid in (8368,8440,8441,8555,220180,220051) and valuenum > 0 and valuenum < 300 then 3 -- DiasBP
    -- when itemid in (456,52,6702,443,220052,220181,225312) and valuenum > 0 and valuenum < 300 then 4 -- MeanBP
    when itemid in (615,618,220210,224690) and valuenum > 0 and valuenum < 70 then 5 -- RespRate
    when itemid in (223761,678) and valuenum > 70 and valuenum < 120  then 6 -- TempF, converted to degC in valuenum call
    when itemid in (223762,676) and valuenum > 10 and valuenum < 50  then 6 -- TempC
    when itemid in (646,220277) and valuenum > 0 and valuenum <= 100 then 7 -- SpO2
    when itemid in (807,811,1529,3745,3744,225664,220621,226537) and valuenum > 0 then 8 -- Glucose
    when itemid in (51,6701,220050) and valuenum > 0 and valuenum < 400 then 9 -- SysBPInv
    when itemid in (8368,8555,220051) and valuenum > 0 and valuenum < 300 then 10 -- DiasBPInv
    when itemid in (442,455,220179) and valuenum > 0 and valuenum < 400 then 11 -- SysBPNI
    when itemid in (8440,8441,220180) and valuenum > 0 and valuenum < 300 then 12 -- DiasBPNI
    when itemid in (52,6702,220052,225312) and valuenum > 0 and valuenum < 400 then 13 -- MBPInv
    when itemid in (456,443,220181) and valuenum > 0 and valuenum < 400 then 14 -- MBPNI
    when itemid in (492,220059) and valuenum > 0 and valuenum < 80 then 15 -- PAPs
    when itemid in (8448,220060) and valuenum > 0 and valuenum < 80 then 16 -- PAPd
    when itemid in (491,220061) and valuenum > 0 and valuenum < 80 then 17 -- PAP mean
    else null end as VitalID
      -- convert F to C
  , case when itemid in (223761,678) then (valuenum-32)/1.8 else valuenum end as valuenum

  from icustays ie
  left join chartevents ce
  on ie.icustay_id = ce.icustay_id
  and ce.charttime between ie.intime - interval '2' hour and ie.intime + interval '1' day
  -- exclude rows marked as error
  and ce.error IS DISTINCT FROM 1
  where ce.itemid in
  (
  -- HEART RATE
  211, --"Heart Rate"
  220045, --"Heart Rate"

  -- Systolic/diastolic
  51, --	Arterial BP [Systolic] i
  442, --	Manual BP [Systolic] ni
  455, --	NBP [Systolic] ni
  6701, --	Arterial BP #2 [Systolic] i
  220179, --	Non Invasive Blood Pressure systolic ni
  220050, --	Arterial Blood Pressure systolic i

  8368, --	Arterial BP [Diastolic] i
  8440, --	Manual BP [Diastolic] ni
  8441, --	NBP [Diastolic] ni
  8555, --	Arterial BP #2 [Diastolic] i
  220180, --	Non Invasive Blood Pressure diastolic ni
  220051, --	Arterial Blood Pressure diastolic i

  -- MEAN ARTERIAL PRESSURE
  456, --"NBP Mean" ni
  52, --"Arterial BP Mean" i
  6702, --	Arterial BP Mean #2 i
  443, --	Manual BP Mean(calc) ni
  220052, --"Arterial Blood Pressure mean" i
  220181, --"Non Invasive Blood Pressure mean" ni
  225312, --"ART BP mean" i

  -- RESPIRATORY RATE
  618,--	Respiratory Rate
  615,--	Resp Rate (Total)
  220210,--	Respiratory Rate
  224690, --	Respiratory Rate (Total)

  -- PULMONARY ARTERY PRESSURE
  492, 220059, -- Pulmonary Artery Pressure systolic, PAPs mmHg
  8448, 220060, -- Pulmonary Artery Pressure diastolic, PAPd mmHg
  491, 220061, -- Pulmonary Artery Pressure mean. PAPm mmHg

  -- SPO2, peripheral
  646, 220277,

  -- GLUCOSE, both lab and fingerstick
  807,--	Fingerstick Glucose
  811,--	Glucose (70-105)
  1529,--	Glucose
  3745,--	BloodGlucose
  3744,--	Blood Glucose
  225664,--	Glucose finger stick
  220621,--	Glucose (serum)
  226537,--	Glucose (whole blood)

  -- TEMPERATURE
  223762, -- "Temperature Celsius"
  676,	-- "Temperature C"
  223761, -- "Temperature Fahrenheit"
  678 --	"Temperature F"

  )
) pvt
group by pvt.subject_id, pvt.hadm_id, pvt.icustay_id
order by pvt.subject_id, pvt.hadm_id, pvt.icustay_id;
