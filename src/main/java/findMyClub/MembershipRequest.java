package findMyClub;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public class MembershipRequest {
    private int id;
    private int studentId;
    private int clubId;

    private String status; // "pending", "approved", "rejected", "cancelled"
    private LocalDateTime requestDate;
    private LocalDateTime responseDate;

    public MembershipRequest(int id, int studentId, int clubId) {
        this.id = id;
        this.studentId = studentId;
        this.clubId = clubId;
        this.status = "pending";
        this.requestDate = LocalDateTime.now();
    }

    public int getId() {
        return id;
    }

    public int getStudentId() {
        return studentId;
    }

    public int getClubId() {
        return clubId;
    }

    public String getStatus() {
        return status;
    }

    public LocalDateTime getRequestDate() {
        return requestDate;
    }

    public LocalDateTime getResponseDate() {
        return responseDate;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public void setResponseDate(LocalDateTime responseDate) {
        this.responseDate = responseDate;
    }

    private static final DateTimeFormatter DATE_FORMAT =
            DateTimeFormatter.ofPattern("MMM d, yyyy");

    public String getFormattedRequestDate() {
        return requestDate.format(DATE_FORMAT);
    }
}