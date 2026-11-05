-- Clinics with 3 or more completed appointments
SELECT
    c.ClinicID,
    c.ClinicName,
    c.Location,
    COUNT(a.AppointmentID) AS CompletedAppointmentCount
FROM Clinic c
JOIN Appointment a 
    ON c.ClinicID = a.ClinicID
WHERE a.Status = 'Completed'
GROUP BY c.ClinicID, c.ClinicName, c.Location
HAVING COUNT(a.AppointmentID) >= 3;