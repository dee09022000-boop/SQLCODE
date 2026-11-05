-- Patients with high-priority follow-ups + their most recent appointment
WITH PatientFollowUpSummary AS (
    SELECT
        a.PatientID,
        fu.FollowUpID,
        fu.DueDate,
        fu.Priority,
        fu.Status AS FollowUpStatus,
        ROW_NUMBER() OVER (PARTITION BY a.PatientID ORDER BY fu.DueDate ASC) AS FollowUpRank
    FROM FollowUpPlan fu
    JOIN Appointment a 
        ON fu.AppointmentID = a.AppointmentID
    WHERE fu.Priority = 'High' AND fu.Status = 'Pending'
)
SELECT
    p.PatientID,
    CONCAT(p.FirstName, ' ', p.LastName) AS PatientName,
    p.NHSNumber,
    f.DueDate AS NextHighPriorityFollowUp,
    f.FollowUpStatus,
    a_latest.AppointmentDate AS MostRecentAppointment,
    a_latest.Status AS LatestAppointmentStatus
FROM Patient p
JOIN PatientFollowUpSummary f 
    ON p.PatientID = f.PatientID
LEFT JOIN Appointment a_latest 
    ON p.PatientID = a_latest.PatientID
WHERE f.FollowUpRank = 1  -- Only the earliest high-priority follow-up
ORDER BY f.DueDate ASC;