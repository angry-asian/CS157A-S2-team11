package findMyClub;

import java.util.ArrayList;
import java.util.List;

public class Club {
    private int id;
    private String name;
    private String description;
    private String category;
    private String meetingLocation;
    private String meetingTime;
    private String communicationPlatform;
    private int leaderId;

    private List<Integer> memberIds = new ArrayList<>();
    private String status; // "pending", "approved", "rejected"
    private String rejectionReason;

    private List<String> keywords = new ArrayList<>();
    private List<ClubEvent> events = new ArrayList<>();

    /** Additional leaders who can co-manage this club. Implements the
     *  many-to-many "Manages" relationship from the design doc. */
    private List<Integer> coLeaderIds = new ArrayList<>();

    public Club(int id, String name, String description, String category,
                String meetingLocation, String meetingTime,
                String communicationPlatform, int leaderId) {

        this.id = id;
        this.name = name;
        this.description = description;
        this.category = category;
        this.meetingLocation = meetingLocation;
        this.meetingTime = meetingTime;
        this.communicationPlatform = communicationPlatform;
        this.leaderId = leaderId;
        this.status = "pending";
    }

    public int getId() {
        return id;
    }

    public String getName() {
        return name;
    }

    public String getDescription() {
        return description;
    }

    public String getCategory() {
        return category;
    }

    public String getMeetingLocation() {
        return meetingLocation;
    }

    public String getMeetingTime() {
        return meetingTime;
    }

    public String getCommunicationPlatform() {
        return communicationPlatform;
    }

    public int getLeaderId() {
        return leaderId;
    }

    public List<Integer> getMemberIds() {
        return memberIds;
    }

    public String getStatus() {
        return status;
    }

    public String getRejectionReason() {
        return rejectionReason;
    }

    public List<String> getKeywords() {
        return keywords;
    }

    public List<ClubEvent> getEvents() {
        return events;
    }

    /** Number of "regular" members — excludes the primary leader and any co-leaders.
     *  Public-facing labels say "students" / "members" which shouldn't double-count
     *  the people running the club. */
    public int getMemberCount() {
        int n = 0;
        for (Integer id : memberIds) {
            if (id == leaderId) continue;
            if (coLeaderIds.contains(id)) continue;
            n++;
        }
        return n;
    }

    /** Total roster size including leader and co-leaders, for callers that need it. */
    public int getTotalRosterSize() {
        return memberIds.size();
    }

    // Setters
    public void setName(String name) {
        this.name = name;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public void setMeetingLocation(String meetingLocation) {
        this.meetingLocation = meetingLocation;
    }

    public void setMeetingTime(String meetingTime) {
        this.meetingTime = meetingTime;
    }

    public void setCommunicationPlatform(String communicationPlatform) {
        this.communicationPlatform = communicationPlatform;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public void setRejectionReason(String rejectionReason) {
        this.rejectionReason = rejectionReason;
    }

    public void addMember(int userId) {
        if (!memberIds.contains(userId)) {
            memberIds.add(userId);
        }
    }

    public void removeMember(int userId) {
        memberIds.remove(Integer.valueOf(userId));
    }

    public void addKeyword(String keyword) {
        if (!keywords.contains(keyword)) {
            keywords.add(keyword);
        }
    }

    public void addEvent(ClubEvent event) {
        events.add(event);
    }

    // ===== Co-leader (many-to-many Manages) helpers =====

    public List<Integer> getCoLeaderIds() {
        return coLeaderIds;
    }

    /** True if userId is the primary leader OR a co-leader of this club. */
    public boolean isManagedBy(int userId) {
        return userId == leaderId || coLeaderIds.contains(userId);
    }

    public boolean addCoLeader(int userId) {
        if (userId == leaderId) return false;          // primary already manages
        if (coLeaderIds.contains(userId)) return false; // dup
        coLeaderIds.add(userId);
        if (!memberIds.contains(userId)) memberIds.add(userId); // co-leaders are members too
        return true;
    }

    public boolean removeCoLeader(int userId) {
        return coLeaderIds.remove(Integer.valueOf(userId));
    }
}