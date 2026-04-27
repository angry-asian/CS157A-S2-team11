package findMyClub;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public class SavedEvent {
    private int id;
    private int userId;
    private int eventId;
    private int clubId;
    private LocalDateTime savedAt;

    public SavedEvent(int id, int userId, int eventId, int clubId) {
        this.id = id;
        this.userId = userId;
        this.eventId = eventId;
        this.clubId = clubId;
        this.savedAt = LocalDateTime.now();
    }

    public int getId() {
        return id;
    }

    public int getUserId() {
        return userId;
    }

    public int getEventId() {
        return eventId;
    }

    public int getClubId() {
        return clubId;
    }
    
    public LocalDateTime getSavedAt() { return savedAt; }

    public String getFormattedSavedAt() {
        DateTimeFormatter fmt = DateTimeFormatter.ofPattern("MMM d, yyyy");
        return savedAt.format(fmt);
    }
}