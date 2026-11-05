WITH UpcomingAppointments AS (
    SELECT
        p.PatientID,
        CONCAT(p.FirstName, ' ', p.LastName) AS PatientName,
        a.AppointmentDate AS EventDateTime,
        c.ClinicName,
        CONCAT(clin.FirstName, ' ', clin.LastName) AS ClinicianName,
        'SCHEDULED APPOINTMENT' AS EventType,
        'Normal' AS Priority
    FROM Appointment a
    JOIN Patient p ON a.PatientID = p.PatientID
    JOIN Clinic c ON a.ClinicID = c.ClinicID
    JOIN Clinician clin ON a.ClinicianID = clin.ClinicianID
    WHERE a.Status = 'Scheduled'
      AND a.AppointmentDate >= NOW()
),
PendingFollowUps AS (
    SELECT
        p.PatientID,
        CONCAT(p.FirstName, ' ', p.LastName) AS PatientName,
        fu.DueDate AS EventDateTime,
        c.ClinicName,
        CONCAT(clin.FirstName, ' ', clin.LastName) AS ClinicianName,
        CONCAT('FOLLOW‑UP: ', fu.Priority) AS EventType,
        fu.Priority
    FROM FollowUpPlan fu
    JOIN Appointment a ON fu.AppointmentID = a.AppointmentID
    JOIN Patient p ON a.PatientID = p.PatientID
    JOIN Clinic c ON a.ClinicID = c.ClinicID
    JOIN Clinician clin ON a.ClinicianID = clin.ClinicianID
    WHERE fu.Status = 'Pending'
)
SELECT * FROM UpcomingAppointments
UNION ALL
SELECT * FROM PendingFollowUps
ORDER BY
    CASE Priority
        WHEN 'High' THEN 1
        WHEN 'Medium' THEN 2
        WHEN 'Low' THEN 3
        ELSE 4
    END,
    EventDateTime ASC;