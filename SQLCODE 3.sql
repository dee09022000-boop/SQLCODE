DELIMITER //

CREATE PROCEDURE GetPatientClinicalHistory(IN input_PatientID INT)
BEGIN
    -- Return full appointment history including diagnoses, treatments, and follow-ups
    SELECT
        p.PatientID,
        CONCAT(p.FirstName, ' ', p.LastName) AS PatientName,
        a.AppointmentID,
        a.AppointmentDate,
        a.Status AS AppointmentStatus,
        c.ClinicName,
        CONCAT(clin.FirstName, ' ', clin.LastName) AS ClinicianName,
        d.DiagnosisName,
        t.TreatmentName,
        fu.DueDate AS FollowUpDue,
        fu.Priority AS FollowUpPriority
    FROM Patient p
    LEFT JOIN Appointment a 
        ON p.PatientID = a.PatientID
    LEFT JOIN Clinic c 
        ON a.ClinicID = c.ClinicID
    LEFT JOIN Clinician clin 
        ON a.ClinicianID = clin.ClinicianID
    LEFT JOIN Diagnosis d 
        ON a.AppointmentID = d.AppointmentID
    LEFT JOIN Treatment t 
        ON a.AppointmentID = t.AppointmentID
    LEFT JOIN FollowUpPlan fu 
        ON a.AppointmentID = fu.AppointmentID
    WHERE p.PatientID = input_PatientID
    ORDER BY a.AppointmentDate DESC;
END //

DELIMITER ;

-- Example execution — replace PatientID to view different records
CALL GetPatientClinicalHistory(1);