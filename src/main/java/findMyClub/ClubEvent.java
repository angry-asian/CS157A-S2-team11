package findMyClub;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public class ClubEvent {
    private int id;
    private String title;
    private String description;
    private String location;
    private LocalDateTime eventDate;
    private int clubId;

    public ClubEvent(int id, String title, String description,
                     String location, LocalDateTime eventDate, int clubId) {
        this.id = id;
        this.title = title;
        this.description = description;
        this.location = location;
        this.eventDate = eventDate;
        this.clubId = clubId;
    }

    public int getId() {
        return id;
    }

    public String getTitle() {
        return title;
    }

    public String getDescription() {
        return description;
    }

    public String getLocation() {
        return location;
    }

    public LocalDateTime getEventDate() {
        return eventDate;
    }

    public int getClubId() {
        return clubId;
    }

    public String getFormattedDate() {
        DateTimeFormatter formatter =
                DateTimeFormatter.ofPattern("MMM d, yyyy 'at' h:mm a");
        return eventDate.format(formatter);
    }
}