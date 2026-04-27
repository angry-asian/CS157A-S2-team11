package findMyClub;

import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.Collectors;

public class DataStore {

    private static DataStore instance;

    private final List<User> users = new ArrayList<>();
    private final List<Club> clubs = new ArrayList<>();
    private final List<MembershipRequest> requests = new ArrayList<>();
    private final List<Message> messages = new ArrayList<>();
    private final List<SavedEvent> savedEvents = new ArrayList<>();

    private int nextUserId = 1;
    private int nextClubId = 1;
    private int nextRequestId = 1;
    private int nextEventId = 1;
    private int nextMessageId = 1;
    private int nextSavedEventId = 1;

    private DataStore() {
        seedData();
    }

    public static synchronized DataStore getInstance() {
        if (instance == null) instance = new DataStore();
        return instance;
    }

    private void seedData() {

        users.add(new User(21, "Alice Smith", "alice.smith@sjsu.edu", "pw1", "student"));
        users.add(new User(22, "Bob Johnson", "bob.johnson@sjsu.edu", "pw2", "student"));
        users.add(new User(23, "Charlie Williams", "charlie.williams@sjsu.edu", "pw3", "student"));
        users.add(new User(24, "Dana Brown", "dana.brown@sjsu.edu", "pw4", "student"));
        users.add(new User(25, "Eve Jones", "eve.jones@sjsu.edu", "pw5", "student"));
        users.add(new User(26, "Liam Nguyen", "liam.nguyen@sjsu.edu", "pw6", "student"));
        users.add(new User(27, "Mia Patel", "mia.patel@sjsu.edu", "pw7", "student"));
        users.add(new User(28, "Noah Kim", "noah.kim@sjsu.edu", "pw8", "student"));
        users.add(new User(29, "Emma Lopez", "emma.lopez@sjsu.edu", "pw9", "student"));
        users.add(new User(30, "Ava Chen", "ava.chen@sjsu.edu", "pw10", "student"));

        users.add(new User(31, "Frank Garcia", "frank.garcia@sjsu.edu", "pw11", "clubLeader"));
        users.add(new User(32, "Grace Miller", "grace.miller@sjsu.edu", "pw12", "clubLeader"));
        users.add(new User(33, "Hank Davis", "hank.davis@sjsu.edu", "pw13", "clubLeader"));
        users.add(new User(34, "Olivia Wang", "olivia.wang@sjsu.edu", "pw14", "clubLeader"));
        users.add(new User(35, "Sophia Lee", "sophia.lee@sjsu.edu", "pw15", "clubLeader"));

        users.add(new User(36, "Ivy Martinez", "ivy.martinez@sjsu.edu", "pw16", "admin"));
        users.add(new User(37, "Jack Wilson", "jack.wilson@sjsu.edu", "pw17", "admin"));
        users.add(new User(38, "Emily Scott", "emily.scott@sjsu.edu", "pw18", "admin"));
        users.add(new User(39, "Daniel Green", "daniel.green@sjsu.edu", "pw19", "admin"));
        users.add(new User(40, "Charlotte Young", "charlotte.young@sjsu.edu", "pw20", "admin"));

        nextUserId = 41;

        Club chess = new Club(21, "Chess Club",
                "A club for chess enthusiasts",
                "Games", "Library, Basement Floor", "Fridays 5 PM", "Discord", 31);
        chess.setStatus("approved");
        chess.getKeywords().addAll(Arrays.asList("chess", "strategy", "games", "board"));
        chess.getMemberIds().add(31);
        chess.getEvents().add(new ClubEvent(nextEventId++, "Weekly Tournament",
                "Open to all skill levels, prizes for top 3!", "Library Basement Floor",
                LocalDateTime.now().plusDays(5), 21));
        clubs.add(chess);

        Club photo = new Club(22, "Photography Club",
                "Explore photography techniques",
                "Arts", "IS 219", "Wednesdays 3 PM", "Instagram Group", 32);
        photo.setStatus("approved");
        photo.getKeywords().addAll(Arrays.asList("photography", "art", "camera", "creative"));
        photo.getMemberIds().add(32);
        clubs.add(photo);

        Club robotics = new Club(23, "Robotics Club",
                "Build and program robots",
                "Technology", "ENGR 325", "Tuesdays 4 PM", "Slack", 33);
        robotics.setStatus("pending");
        robotics.getKeywords().addAll(Arrays.asList("robotics", "engineering", "programming", "build"));
        robotics.getMemberIds().add(33);
        clubs.add(robotics);

        Club fencing = new Club(24, "Fencing Club",
                "Recreational Fencing",
                "Sports", "Event Center", "Tuesdays 4 PM", "Discord", 34);
        fencing.setStatus("approved");
        fencing.getKeywords().addAll(Arrays.asList("fencing", "sports", "martial", "recreation"));
        fencing.getMemberIds().add(34);
        clubs.add(fencing);

        Club dnd = new Club(25, "DnD Club",
                "A club to play DnD",
                "Games", "Online", "TBD", "Discord", 32);
        dnd.setStatus("approved");
        dnd.getKeywords().addAll(Arrays.asList("dnd", "dungeons", "dragons", "roleplay", "tabletop"));
        dnd.getMemberIds().add(32);
        clubs.add(dnd);

        Club debate = new Club(26, "Debate Club",
                "Develop debating skills",
                "Academic", "SH 425", "Fridays 4 PM", "Discord", 33);
        debate.setStatus("rejected");
        debate.setRejectionReason("Missing faculty advisor information.");
        debate.getKeywords().addAll(Arrays.asList("debate", "speech", "academic", "argumentation"));
        debate.getMemberIds().add(33);
        clubs.add(debate);

        Club music = new Club(27, "Music Club",
                "Practice and perform music",
                "Performing Arts", "MUS 106", "Wednesdays 5 PM", "Discord", 34);
        music.setStatus("approved");
        music.getKeywords().addAll(Arrays.asList("music", "performance", "instruments", "arts"));
        music.getMemberIds().add(34);
        music.getEvents().add(new ClubEvent(nextEventId++, "Spring Concert",
                "End of semester performance open to all students!", "MUS 106",
                LocalDateTime.now().plusDays(14), 27));
        clubs.add(music);

        Club science = new Club(28, "Science Club",
                "Explore scientific topics",
                "Academic", "ENGR 320", "Thursdays 3 PM", "Slack", 35);
        science.setStatus("approved");
        science.getKeywords().addAll(Arrays.asList("science", "research", "experiments", "academic"));
        science.getMemberIds().add(35);
        clubs.add(science);

        Club literature = new Club(29, "Literature Club",
                "Discuss books and writing",
                "Arts", "SH 102", "Mondays 3 PM", "Discord", 31);
        literature.setStatus("approved");
        literature.getKeywords().addAll(Arrays.asList("books", "writing", "literature", "reading"));
        literature.getMemberIds().add(31);
        clubs.add(literature);

        Club gaming = new Club(30, "Gaming Club",
                "Video game tournaments",
                "Games", "Online", "Saturdays 1 PM", "Discord", 35);
        gaming.setStatus("pending");
        gaming.getKeywords().addAll(Arrays.asList("gaming", "videogames", "esports", "tournaments"));
        gaming.getMemberIds().add(35);
        clubs.add(gaming);

        nextClubId = 31;
        nextEventId = 10;

        messages.add(new Message(nextMessageId++, 21, 31, "Hi! I want to join the Chess Club."));
        messages.add(new Message(nextMessageId++, 31, 21, "Welcome! Please submit a membership request."));
        messages.add(new Message(nextMessageId++, 22, 32, "When is the Photography Club meeting?"));
        messages.add(new Message(nextMessageId++, 32, 22, "Every Wednesday at 3 PM in IS 219."));
        messages.add(new Message(nextMessageId++, 23, 33, "Can I help with the Robotics build session?"));
        messages.add(new Message(nextMessageId++, 24, 34, "Is the Fencing Club open for new members?"));
        messages.add(new Message(nextMessageId++, 25, 35, "How do I join the D&D Club online?"));
    }

    public synchronized User registerUser(String name, String email, String password, String role) {
        boolean exists = users.stream().anyMatch(u -> u.getEmail().equalsIgnoreCase(email));
        if (exists) return null;
        User u = new User(nextUserId++, name, email, password, role);
        users.add(u);
        return u;
    }

    public User loginUser(String email, String password) {
        return users.stream()
                .filter(u -> u.getEmail().equalsIgnoreCase(email)
                        && u.getPassword().equals(password))
                .findFirst().orElse(null);
    }

    public User getUserById(int id) {
        return users.stream()
                .filter(u -> u.getId() == id)
                .findFirst().orElse(null);
    }

    public List<User> getAllUsers() {
        return users;
    }

    public List<Club> searchClubs(String query, String category, String sortBy) {
        List<Club> result = clubs.stream()
                .filter(c -> "approved".equals(c.getStatus()))
                .collect(Collectors.toList());

        if (query != null && !query.trim().isEmpty()) {
            String q = query.toLowerCase();
            result = result.stream().filter(c ->
                    c.getName().toLowerCase().contains(q) ||
                            c.getDescription().toLowerCase().contains(q) ||
                            c.getCategory().toLowerCase().contains(q) ||
                            c.getKeywords().stream().anyMatch(k -> k.toLowerCase().contains(q))
            ).collect(Collectors.toList());
        }

        if (category != null && !category.isEmpty() && !"All".equals(category)) {
            result = result.stream()
                    .filter(c -> c.getCategory().equals(category))
                    .collect(Collectors.toList());
        }

        if ("size".equals(sortBy)) {
            result.sort((a, b) -> b.getMemberCount() - a.getMemberCount());
        } else {
            result.sort(Comparator.comparing(Club::getName));
        }

        return result;
    }

    public Club getClubById(int id) {
        return clubs.stream()
                .filter(c -> c.getId() == id)
                .findFirst().orElse(null);
    }

    public synchronized Club createClub(String name, String description, String category,
                                        String location, String time, String comm, int leaderId) {
        Club c = new Club(nextClubId++, name, description, category, location, time, comm, leaderId);
        c.setStatus("pending");
        c.getMemberIds().add(leaderId);
        clubs.add(c);
        return c;
    }

    public List<Club> getClubsByLeader(int leaderId) {
        return clubs.stream()
                .filter(c -> c.getLeaderId() == leaderId)
                .collect(Collectors.toList());
    }

    public List<Club> getAllApprovedClubs() {
        return clubs.stream()
                .filter(c -> "approved".equals(c.getStatus()))
                .collect(Collectors.toList());
    }

    public List<Club> getAllClubs() {
        return clubs;
    }

    public List<String> getCategories() {
        return Arrays.asList(
                "Academic", "Arts", "Games", "Performing Arts", "Sports", "Technology", "Other"
        );
    }

    public synchronized MembershipRequest submitRequest(int studentId, int clubId) {
        boolean already = requests.stream().anyMatch(r ->
                r.getStudentId() == studentId &&
                        r.getClubId() == clubId &&
                        "pending".equals(r.getStatus()));
        if (already) return null;
        MembershipRequest r = new MembershipRequest(nextRequestId++, studentId, clubId);
        requests.add(r);
        return r;
    }

    public List<MembershipRequest> getRequestsByStudent(int studentId) {
        return requests.stream()
                .filter(r -> r.getStudentId() == studentId)
                .collect(Collectors.toList());
    }

    public List<MembershipRequest> getPendingRequestsForClub(int clubId) {
        return requests.stream()
                .filter(r -> r.getClubId() == clubId && "pending".equals(r.getStatus()))
                .collect(Collectors.toList());
    }

    public List<MembershipRequest> getAllRequestsForClub(int clubId) {
        return requests.stream()
                .filter(r -> r.getClubId() == clubId)
                .collect(Collectors.toList());
    }

    public boolean cancelRequest(int requestId, int studentId) {
        for (MembershipRequest r : requests) {
            if (r.getId() == requestId &&
                    r.getStudentId() == studentId &&
                    "pending".equals(r.getStatus())) {
                r.setStatus("cancelled");
                return true;
            }
        }
        return false;
    }

    public boolean processRequest(int requestId, String decision, int leaderId) {
        for (MembershipRequest r : requests) {
            if (r.getId() == requestId && "pending".equals(r.getStatus())) {
                Club club = getClubById(r.getClubId());
                if (club != null && club.getLeaderId() == leaderId) {
                    r.setStatus(decision);
                    r.setResponseDate(LocalDateTime.now());
                    if ("approved".equals(decision)) {
                        club.getMemberIds().add(r.getStudentId());
                    }
                    return true;
                }
            }
        }
        return false;
    }

    public List<MembershipRequest> getAllRequests() {
        return requests;
    }

    public List<Club> getPendingClubs() {
        return clubs.stream()
                .filter(c -> "pending".equals(c.getStatus()))
                .collect(Collectors.toList());
    }

    public boolean approveClub(int clubId) {
        Club c = getClubById(clubId);
        if (c != null && "pending".equals(c.getStatus())) {
            c.setStatus("approved");
            return true;
        }
        return false;
    }

    public boolean rejectClub(int clubId, String reason) {
        Club c = getClubById(clubId);
        if (c != null && "pending".equals(c.getStatus())) {
            c.setStatus("rejected");
            c.setRejectionReason(reason);
            return true;
        }
        return false;
    }

    public boolean updateUserRole(int userId, String newRole) {
        User u = getUserById(userId);
        if (u != null) {
            u.setRole(newRole);
            return true;
        }
        return false;
    }

    public synchronized Message sendMessage(int senderId, int receiverId, String content) {
        if (content == null || content.trim().isEmpty()) return null;
        Message m = new Message(nextMessageId++, senderId, receiverId, content.trim());
        messages.add(m);
        return m;
    }

    /** All conversations for a user: grouped by the other party. */
    public List<Integer> getConversationPartners(int userId) {
        Set<Integer> partners = new LinkedHashSet<>();
        for (Message m : messages) {
            if (m.getSenderId() == userId)   partners.add(m.getReceiverId());
            if (m.getReceiverId() == userId) partners.add(m.getSenderId());
        }
        return new ArrayList<>(partners);
    }

    public List<Message> getConversation(int userId, int partnerId) {
        return messages.stream()
                .filter(m -> (m.getSenderId() == userId   && m.getReceiverId() == partnerId)
                          || (m.getSenderId() == partnerId && m.getReceiverId() == userId))
                .sorted(Comparator.comparing(Message::getSentAt))
                .collect(Collectors.toList());
    }

    public int getUnreadCount(int userId) {
        return (int) messages.stream()
                .filter(m -> m.getReceiverId() == userId && !m.isRead())
                .count();
    }

    public void markConversationRead(int userId, int partnerId) {
        messages.stream()
                .filter(m -> m.getSenderId() == partnerId && m.getReceiverId() == userId)
                .forEach(m -> m.setRead(true));
    }

    public List<Message> getAllMessages() { return messages; }

    public synchronized SavedEvent saveEvent(int userId, int eventId, int clubId) {
        boolean already = savedEvents.stream()
                .anyMatch(s -> s.getUserId() == userId && s.getEventId() == eventId);
        if (already) return null;
        SavedEvent se = new SavedEvent(nextSavedEventId++, userId, eventId, clubId);
        savedEvents.add(se);
        return se;
    }

    public boolean unsaveEvent(int userId, int eventId) {
        return savedEvents.removeIf(s -> s.getUserId() == userId && s.getEventId() == eventId);
    }

    public boolean isEventSaved(int userId, int eventId) {
        return savedEvents.stream()
                .anyMatch(s -> s.getUserId() == userId && s.getEventId() == eventId);
    }

    public List<SavedEvent> getSavedEventsForUser(int userId) {
        return savedEvents.stream()
                .filter(s -> s.getUserId() == userId)
                .collect(Collectors.toList());
    }

    /** Find a ClubEvent by its id across all clubs. */
    public ClubEvent getEventById(int eventId) {
        for (Club c : clubs) {
            for (ClubEvent e : c.getEvents()) {
                if (e.getId() == eventId) return e;
            }
        }
        return null;
    }

    /** Find the Club that owns the given event id, or null. */
    public Club getClubForEvent(int eventId) {
        for (Club c : clubs) {
            for (ClubEvent e : c.getEvents()) {
                if (e.getId() == eventId) return c;
            }
        }
        return null;
    }

    /** All events across all approved clubs. */
    public List<ClubEvent> getAllEvents() {
        List<ClubEvent> all = new ArrayList<>();
        for (Club c : clubs) {
            if ("approved".equals(c.getStatus())) {
                all.addAll(c.getEvents());
            }
        }
        all.sort(Comparator.comparing(ClubEvent::getEventDate));
        return all;
    }

    /** All events for a single club, sorted by date. */
    public List<ClubEvent> getEventsByClub(int clubId) {
        Club c = getClubById(clubId);
        if (c == null) return new ArrayList<>();
        List<ClubEvent> list = new ArrayList<>(c.getEvents());
        list.sort(Comparator.comparing(ClubEvent::getEventDate));
        return list;
    }

    /** All events across every club led by the given user, sorted by date. */
    public List<ClubEvent> getEventsByLeader(int leaderId) {
        List<ClubEvent> all = new ArrayList<>();
        for (Club c : clubs) {
            if (c.getLeaderId() == leaderId) {
                all.addAll(c.getEvents());
            }
        }
        all.sort(Comparator.comparing(ClubEvent::getEventDate));
        return all;
    }

    /** Create an event under a club. Caller must be the club's leader. */
    public synchronized ClubEvent createEvent(int clubId, int leaderId,
                                              String title, String description,
                                              String location, LocalDateTime eventDate) {
        if (title == null || title.trim().isEmpty()) return null;
        if (eventDate == null) return null;

        Club c = getClubById(clubId);
        if (c == null || c.getLeaderId() != leaderId) return null;

        ClubEvent e = new ClubEvent(nextEventId++,
                title.trim(),
                description == null ? "" : description.trim(),
                location == null ? "" : location.trim(),
                eventDate,
                clubId);
        c.getEvents().add(e);
        return e;
    }

    /** Update an event. Caller must be the parent club's leader. */
    public synchronized boolean updateEvent(int eventId, int leaderId,
                                            String title, String description,
                                            String location, LocalDateTime eventDate) {
        Club c = getClubForEvent(eventId);
        if (c == null || c.getLeaderId() != leaderId) return false;

        ClubEvent e = getEventById(eventId);
        if (e == null) return false;

        if (title != null && !title.trim().isEmpty()) e.setTitle(title.trim());
        e.setDescription(description == null ? "" : description.trim());
        e.setLocation(location == null ? "" : location.trim());
        if (eventDate != null) e.setEventDate(eventDate);
        return true;
    }

    /** Delete an event. Caller must be the parent club's leader. Also drops saved-event refs. */
    public synchronized boolean deleteEvent(int eventId, int leaderId) {
        Club c = getClubForEvent(eventId);
        if (c == null || c.getLeaderId() != leaderId) return false;

        boolean removed = c.getEvents().removeIf(e -> e.getId() == eventId);
        if (removed) {
            savedEvents.removeIf(s -> s.getEventId() == eventId);
        }
        return removed;
    }

    /** Returns true if the club already has an event within 60 minutes of the candidate.
     *  ignoreEventId allows skipping a specific event id (used when updating). */
    public boolean hasEventConflict(int clubId, LocalDateTime when, Integer ignoreEventId) {
        if (when == null) return false;
        Club c = getClubById(clubId);
        if (c == null) return false;
        for (ClubEvent e : c.getEvents()) {
            if (ignoreEventId != null && e.getId() == ignoreEventId.intValue()) continue;
            long minutes = Math.abs(java.time.Duration.between(e.getEventDate(), when).toMinutes());
            if (minutes < 60) return true;
        }
        return false;
    }

    /** Members of a club as full User objects. */
    public List<User> getMembersByClub(int clubId) {
        Club c = getClubById(clubId);
        if (c == null) return new ArrayList<>();
        List<User> list = new ArrayList<>();
        for (Integer id : c.getMemberIds()) {
            User u = getUserById(id);
            if (u != null) list.add(u);
        }
        return list;
    }

    /** Remove a member from a club. Caller must be the club's leader.
     *  The leader cannot remove themselves through this path. */
    public synchronized boolean removeMember(int clubId, int userId, int leaderId) {
        Club c = getClubById(clubId);
        if (c == null || c.getLeaderId() != leaderId) return false;
        if (userId == leaderId) return false; // can't remove the leader
        return c.getMemberIds().removeIf(id -> id == userId);
    }

    /** All other users with the clubLeader role (excluding the current user). */
    public List<User> getOtherClubLeaders(int excludeUserId) {
        return users.stream()
                .filter(u -> "clubLeader".equals(u.getRole()) && u.getId() != excludeUserId)
                .sorted(Comparator.comparing(User::getName))
                .collect(Collectors.toList());
    }

    /** Non-pending request history for all clubs led by the given leader. */
    public List<MembershipRequest> getRequestHistoryByLeader(int leaderId) {
        List<MembershipRequest> all = new ArrayList<>();
        for (Club c : getClubsByLeader(leaderId)) {
            for (MembershipRequest r : getAllRequestsForClub(c.getId())) {
                if (!"pending".equals(r.getStatus())) all.add(r);
            }
        }
        all.sort((a, b) -> {
            LocalDateTime da = a.getResponseDate() != null ? a.getResponseDate() : a.getRequestDate();
            LocalDateTime db = b.getResponseDate() != null ? b.getResponseDate() : b.getRequestDate();
            return db.compareTo(da); // newest first
        });
        return all;
    }
}