package findMyClub;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

/**
 * Tracks state-changing events across the system.
 * Required by spec: "System maintains a log for all changes."
 *
 * One row per change. The actor (userId) plus a free-form action string and
 * an optional human-readable detail let us render this both as a per-user
 * activity feed and as a system-wide audit table for admins.
 */
public class AuditLog {

    private int id;
    private int actorId;          // user who took the action
    private String action;        // e.g. "createClub", "approveRequest"
    private String targetType;    // e.g. "Club", "MembershipRequest", "ClubEvent"
    private int targetId;         // id of the affected entity (0 if N/A)
    private String details;       // human-readable extra context
    private LocalDateTime occurredAt;

    public AuditLog(int id, int actorId, String action,
                    String targetType, int targetId, String details) {
        this.id = id;
        this.actorId = actorId;
        this.action = action;
        this.targetType = targetType;
        this.targetId = targetId;
        this.details = details == null ? "" : details;
        this.occurredAt = LocalDateTime.now();
    }

    public int getId() { return id; }
    public int getActorId() { return actorId; }
    public String getAction() { return action; }
    public String getTargetType() { return targetType; }
    public int getTargetId() { return targetId; }
    public String getDetails() { return details; }
    public LocalDateTime getOccurredAt() { return occurredAt; }

    public String getFormattedDate() {
        DateTimeFormatter fmt = DateTimeFormatter.ofPattern("MMM d, yyyy 'at' h:mm a");
        return occurredAt.format(fmt);
    }
}
