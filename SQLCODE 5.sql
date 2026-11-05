-- Clinicians who have issued 2 or more prescriptions
SELECT
    c.ClinicianID,
    CONCAT(c.FirstName, ' ', c.LastName) AS ClinicianName,
    s.SpecialtyName,
    COUNT(DISTINCT pr.PrescriptionID) AS TotalPrescriptionsIssued
FROM Clinician c
INNER JOIN Specialty s
    ON c.SpecialtyID = s.SpecialtyID
INNER JOIN Appointment a
    ON c.ClinicianID = a.ClinicianID
INNER JOIN Prescription pr
    ON a.AppointmentID = pr.AppointmentID
GROUP BY c.ClinicianID, ClinicianName, s.SpecialtyName
HAVING COUNT(DISTINCT pr.PrescriptionID) >= 2;