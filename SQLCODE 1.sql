-- Full prescription details: Patient → Appointment → Prescription → Medicine
SELECT
    p.PatientID,
    CONCAT(p.FirstName, ' ', p.LastName) AS PatientName,
    a.AppointmentID,
    a.AppointmentDate,
    CONCAT(c.FirstName, ' ', c.LastName) AS PrescribingClinician,
    pr.PrescriptionDate,
    m.MedicineName,
    pi.Dose,
    pi.Route,
    pi.Frequency,
    pi.DurationDays
FROM Patient p
INNER JOIN Appointment a 
    ON p.PatientID = a.PatientID
INNER JOIN Clinician c 
    ON a.ClinicianID = c.ClinicianID
INNER JOIN Prescription pr 
    ON a.AppointmentID = pr.AppointmentID
INNER JOIN PrescriptionItem pi 
    ON pr.PrescriptionID = pi.PrescriptionID
INNER JOIN Medicine m 
    ON pi.MedicineID = m.MedicineID
ORDER BY pr.PrescriptionDate DESC;