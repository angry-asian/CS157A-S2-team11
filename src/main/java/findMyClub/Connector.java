package findMyClub;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeParseException;
import java.util.*;

@SuppressWarnings("serial")
@WebServlet("/app/*")
public class Connector extends HttpServlet {

    private DataStore ds;

    @Override
    public void init() {
        ds = DataStore.getInstance();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String path = req.getPathInfo();
        if (path == null || path.equals("/")) path = "/search";

        switch (path) {
            case "/login":
                forward(req, resp, "/login.jsp");
                break;

            case "/register":
                forward(req, resp, "/register.jsp");
                break;

            case "/logout":
                HttpSession s = req.getSession(false);
                if (s != null) s.invalidate();
                resp.sendRedirect(req.getContextPath() + "/app/login");
                break;

            case "/search":
                handleSearch(req, resp);
                break;

            case "/club":
                handleViewClub(req, resp);
                break;

            case "/studentDashboard":
                if (!checkLogin(req, resp)) return;
                handleStudentDashboard(req, resp);
                break;

            case "/clubLeaderDashboard":
                if (!checkLogin(req, resp)) return;
                handleClubLeaderDashboard(req, resp);
                break;

            case "/adminDashboard":
                if (!checkLogin(req, resp)) return;
                if (!"admin".equals(req.getSession().getAttribute("userRole"))) {
                    resp.sendRedirect(req.getContextPath() + "/app/search");
                    return;
                }
                handleAdminDashboard(req, resp);
                break;

            case "/messages":
                if (!checkLogin(req, resp)) return;
                handleMessages(req, resp);
                break;

            case "/savedEvents":
                if (!checkLogin(req, resp)) return;
                handleSavedEvents(req, resp);
                break;

            default:
                resp.sendRedirect(req.getContextPath() + "/app/search");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String path = req.getPathInfo();
        if (path == null) path = "/";

        switch (path) {
            case "/login":
                handleLogin(req, resp);
                break;

            case "/register":
                handleRegister(req, resp);
                break;

            case "/joinRequest":
                handleJoinRequest(req, resp);
                break;

            case "/cancelRequest":
                handleCancelRequest(req, resp);
                break;

            case "/createClub":
                handleCreateClub(req, resp);
                break;

            case "/updateClub":
                handleUpdateClub(req, resp);
                break;

            case "/processRequest":
                handleProcessRequest(req, resp);
                break;

            case "/approveClub":
                if (!checkLogin(req, resp)) return;
                handleApproveClub(req, resp);
                break;

            case "/rejectClub":
                if (!checkLogin(req, resp)) return;
                handleRejectClub(req, resp);
                break;

            case "/updateUserRole":
                if (!checkLogin(req, resp)) return;
                handleUpdateUserRole(req, resp);
                break;

            case "/sendMessage":
                if (!checkLogin(req, resp)) return;
                handleSendMessage(req, resp);
                break;

            case "/saveEvent":
                if (!checkLogin(req, resp)) return;
                handleSaveEvent(req, resp);
                break;

            case "/unsaveEvent":
                if (!checkLogin(req, resp)) return;
                handleUnsaveEvent(req, resp);
                break;

            case "/createEvent":
                if (!checkLogin(req, resp)) return;
                handleCreateEvent(req, resp);
                break;

            case "/updateEvent":
                if (!checkLogin(req, resp)) return;
                handleUpdateEvent(req, resp);
                break;

            case "/deleteEvent":
                if (!checkLogin(req, resp)) return;
                handleDeleteEvent(req, resp);
                break;

            case "/removeMember":
                if (!checkLogin(req, resp)) return;
                handleRemoveMember(req, resp);
                break;

            default:
                resp.sendRedirect(req.getContextPath() + "/app/search");
        }
    }

    private boolean checkLogin(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession s = req.getSession(false);
        if (s == null || s.getAttribute("userId") == null) {
            resp.sendRedirect(req.getContextPath() + "/app/login");
            return false;
        }
        return true;
    }

    private void forward(HttpServletRequest req, HttpServletResponse resp, String jsp)
            throws ServletException, IOException {
        req.getRequestDispatcher(jsp).forward(req, resp);
    }

    private void handleSearch(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String query = req.getParameter("q");
        String category = req.getParameter("category");
        String sortBy = req.getParameter("sort");

        req.setAttribute("clubs", ds.searchClubs(query, category, sortBy));
        req.setAttribute("query", query);
        req.setAttribute("selectedCategory", category);
        req.setAttribute("sortBy", sortBy);
        req.setAttribute("categories", ds.getCategories());

        forward(req, resp, "/FindMyClub.jsp");
    }

    private void handleViewClub(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String idStr = req.getParameter("id");
        if (idStr == null) {
            resp.sendRedirect(req.getContextPath() + "/app/search");
            return;
        }

        Club club = ds.getClubById(Integer.parseInt(idStr));
        if (club == null) {
            resp.sendRedirect(req.getContextPath() + "/app/search");
            return;
        }

        req.setAttribute("club", club);
        req.setAttribute("leader", ds.getUserById(club.getLeaderId()));

        HttpSession session = req.getSession(false);
        if (session != null && session.getAttribute("userId") != null) {
            int userId = (int) session.getAttribute("userId");

            ds.getRequestsByStudent(userId).stream()
                    .filter(r -> r.getClubId() == club.getId())
                    .findFirst()
                    .ifPresent(r -> req.setAttribute("myRequest", r));

            req.setAttribute("isMember", club.getMemberIds().contains(userId));
        }

        String msg = req.getParameter("msg");
        if (msg != null) req.setAttribute("flashMsg", msg);

        forward(req, resp, "/clubDetail.jsp");
    }

    private void handleStudentDashboard(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        int userId = (int) req.getSession().getAttribute("userId");

        List<Map<String, Object>> enrichedRequests = new ArrayList<>();
        for (MembershipRequest r : ds.getRequestsByStudent(userId)) {
            Map<String, Object> m = new HashMap<>();
            m.put("request", r);
            m.put("club", ds.getClubById(r.getClubId()));
            enrichedRequests.add(m);
        }

        req.setAttribute("myRequests", enrichedRequests);

        List<Club> myClubs = new ArrayList<>();
        for (Club c : ds.getAllApprovedClubs()) {
            if (c.getMemberIds().contains(userId)) {
                myClubs.add(c);
            }
        }

        req.setAttribute("myClubs", myClubs);
        forward(req, resp, "/studentDashboard.jsp");
    }

    private void handleClubLeaderDashboard(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        int userId = (int) req.getSession().getAttribute("userId");

        List<Club> myClubs = ds.getClubsByLeader(userId);
        req.setAttribute("myClubs", myClubs);
        req.setAttribute("categories", ds.getCategories());

        // For each club, attach its non-leader member roster as a paired list-of-maps.
        List<Map<String, Object>> myClubsWithMembers = new ArrayList<>();
        for (Club c : myClubs) {
            List<User> members = new ArrayList<>();
            for (User u : ds.getMembersByClub(c.getId())) {
                if (u.getId() != c.getLeaderId()) members.add(u);
            }
            Map<String, Object> entry = new HashMap<>();
            entry.put("club", c);
            entry.put("members", members);
            myClubsWithMembers.add(entry);
        }
        req.setAttribute("myClubsWithMembers", myClubsWithMembers);

        List<Map<String, Object>> pending = new ArrayList<>();
        for (Club c : myClubs) {
            for (MembershipRequest r : ds.getPendingRequestsForClub(c.getId())) {
                Map<String, Object> m = new HashMap<>();
                m.put("request", r);
                m.put("student", ds.getUserById(r.getStudentId()));
                m.put("club", c);
                pending.add(m);
            }
        }

        req.setAttribute("pendingRequests", pending);

        List<Map<String, Object>> myEvents = new ArrayList<>();
        for (Club c : myClubs) {
            for (ClubEvent e : c.getEvents()) {
                Map<String, Object> m = new HashMap<>();
                m.put("event", e);
                m.put("club", c);
                myEvents.add(m);
            }
        }
        myEvents.sort((a, b) -> {
            ClubEvent ea = (ClubEvent) a.get("event");
            ClubEvent eb = (ClubEvent) b.get("event");
            return ea.getEventDate().compareTo(eb.getEventDate());
        });
        req.setAttribute("myEvents", myEvents);


        // Past requests (approved/rejected/cancelled) across the leader's clubs
        List<Map<String, Object>> pastRequests = new ArrayList<>();
        for (MembershipRequest r : ds.getRequestHistoryByLeader(userId)) {
            Map<String, Object> m = new HashMap<>();
            m.put("request", r);
            m.put("student", ds.getUserById(r.getStudentId()));
            m.put("club", ds.getClubById(r.getClubId()));
            pastRequests.add(m);
        }
        req.setAttribute("pastRequests", pastRequests);

        // Other club leaders (contact list)
        req.setAttribute("otherLeaders", ds.getOtherClubLeaders(userId));

        String msg = req.getParameter("msg");
        if (msg != null) req.setAttribute("flashMsg", msg);

        forward(req, resp, "/clubLeaderDashboard.jsp");
    }

    private void handleLogin(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String email = req.getParameter("email");
        String password = req.getParameter("password");

        User user = ds.loginUser(email, password);

        if (user == null) {
            req.setAttribute("error", "Invalid email or password.");
            forward(req, resp, "/login.jsp");
            return;
        }

        HttpSession session = req.getSession();
        session.setAttribute("userId", user.getId());
        session.setAttribute("userName", user.getName());
        session.setAttribute("userRole", user.getRole());

        switch (user.getRole()) {
            case "clubLeader":
                resp.sendRedirect(req.getContextPath() + "/app/clubLeaderDashboard");
                break;

            case "admin":
                resp.sendRedirect(req.getContextPath() + "/app/adminDashboard");
                break;

            default:
                resp.sendRedirect(req.getContextPath() + "/app/studentDashboard");
                break;
        }
    }

    private void handleRegister(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String name = req.getParameter("name");
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        String confirm = req.getParameter("confirmPassword");
        String role = req.getParameter("role");

        if (role == null) role = "student";

        if (name == null || name.trim().isEmpty()) {
            req.setAttribute("error", "Full name is required.");
            forward(req, resp, "/register.jsp");
            return;
        }

        if (email == null || !email.matches(".+@.+\\.edu")) {
            req.setAttribute("error", "Please use a valid university (.edu) email.");
            forward(req, resp, "/register.jsp");
            return;
        }

        if (password == null || password.length() < 6) {
            req.setAttribute("error", "Password must be at least 6 characters.");
            forward(req, resp, "/register.jsp");
            return;
        }

        if (!password.equals(confirm)) {
            req.setAttribute("error", "Passwords do not match.");
            forward(req, resp, "/register.jsp");
            return;
        }

        User user = ds.registerUser(name.trim(), email.trim(), password, role);

        if (user == null) {
            req.setAttribute("error", "An account with this email already exists.");
            forward(req, resp, "/register.jsp");
            return;
        }

        req.setAttribute("success", "Account created! You can now log in.");
        forward(req, resp, "/login.jsp");
    }

    private void handleJoinRequest(HttpServletRequest req, HttpServletResponse resp)
            throws IOException, ServletException {

        if (!checkLogin(req, resp)) return;

        int userId = (int) req.getSession().getAttribute("userId");
        int clubId = Integer.parseInt(req.getParameter("clubId"));

        MembershipRequest r = ds.submitRequest(userId, clubId);
        String msg = (r == null) ? "alreadyRequested" : "requested";

        resp.sendRedirect(req.getContextPath() + "/app/club?id=" + clubId + "&msg=" + msg);
    }

    private void handleCancelRequest(HttpServletRequest req, HttpServletResponse resp)
            throws IOException, ServletException {

        if (!checkLogin(req, resp)) return;

        int userId = (int) req.getSession().getAttribute("userId");
        int requestId = Integer.parseInt(req.getParameter("requestId"));
        int clubId = Integer.parseInt(req.getParameter("clubId"));

        ds.cancelRequest(requestId, userId);

        resp.sendRedirect(req.getContextPath() + "/app/club?id=" + clubId + "&msg=cancelled");
    }

    private void handleCreateClub(HttpServletRequest req, HttpServletResponse resp)
            throws IOException, ServletException {

        if (!checkLogin(req, resp)) return;

        int userId = (int) req.getSession().getAttribute("userId");
        String name = req.getParameter("name");

        if (name == null || name.trim().isEmpty()) {
            req.setAttribute("error", "Club name is required.");
            handleClubLeaderDashboard(req, resp);
            return;
        }

        ds.createClub(
                name.trim(),
                req.getParameter("description"),
                req.getParameter("category"),
                req.getParameter("meetingLocation"),
                req.getParameter("meetingTime"),
                req.getParameter("communicationPlatform"),
                userId
        );

        resp.sendRedirect(req.getContextPath() + "/app/clubLeaderDashboard?msg=created");
    }

    private void handleUpdateClub(HttpServletRequest req, HttpServletResponse resp)
            throws IOException, ServletException {

        if (!checkLogin(req, resp)) return;

        int userId = (int) req.getSession().getAttribute("userId");
        int clubId = Integer.parseInt(req.getParameter("clubId"));

        Club club = ds.getClubById(clubId);

        if (club != null && club.getLeaderId() == userId) {
            club.setDescription(req.getParameter("description"));
            club.setMeetingLocation(req.getParameter("meetingLocation"));
            club.setMeetingTime(req.getParameter("meetingTime"));
            club.setCommunicationPlatform(req.getParameter("communicationPlatform"));
        }

        resp.sendRedirect(req.getContextPath() + "/app/clubLeaderDashboard?msg=updated");
    }

    private void handleProcessRequest(HttpServletRequest req, HttpServletResponse resp)
            throws IOException, ServletException {

        if (!checkLogin(req, resp)) return;

        int userId = (int) req.getSession().getAttribute("userId");
        int requestId = Integer.parseInt(req.getParameter("requestId"));
        String decision = req.getParameter("decision");

        ds.processRequest(requestId, decision, userId);

        resp.sendRedirect(req.getContextPath() + "/app/clubLeaderDashboard?msg=" + decision);
    }

    private void handleAdminDashboard(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setAttribute("pendingClubs",   ds.getPendingClubs());
        req.setAttribute("allUsers",       ds.getAllUsers());
        req.setAttribute("allRequests",    ds.getAllRequests());
        req.setAttribute("allEvents",      ds.getAllEvents());
        req.setAttribute("allMessages",    ds.getAllMessages());
        req.setAttribute("allClubs",       ds.getAllClubs());

        String msg = req.getParameter("msg");
        if (msg != null) req.setAttribute("flashMsg", msg);

        forward(req, resp, "/adminDashboard.jsp");
    }

    private void handleApproveClub(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        int clubId = Integer.parseInt(req.getParameter("clubId"));
        ds.approveClub(clubId);
        resp.sendRedirect(req.getContextPath() + "/app/adminDashboard?msg=approved");
    }

    private void handleRejectClub(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        int clubId = Integer.parseInt(req.getParameter("clubId"));
        String reason = req.getParameter("reason");
        if (reason == null || reason.trim().isEmpty()) reason = "Does not meet campus policies.";
        ds.rejectClub(clubId, reason.trim());
        resp.sendRedirect(req.getContextPath() + "/app/adminDashboard?msg=rejected");
    }

    private void handleUpdateUserRole(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        int userId = Integer.parseInt(req.getParameter("userId"));
        String newRole = req.getParameter("newRole");
        ds.updateUserRole(userId, newRole);
        resp.sendRedirect(req.getContextPath() + "/app/adminDashboard?msg=roleUpdated");
    }

    private void handleMessages(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        int userId = (int) req.getSession().getAttribute("userId");

        List<Integer> partnerIds = ds.getConversationPartners(userId);
        List<Map<String, Object>> conversations = new ArrayList<>();
        for (int pid : partnerIds) {
            User partner = ds.getUserById(pid);
            if (partner == null) continue;
            List<Message> thread = ds.getConversation(userId, pid);
            Map<String, Object> conv = new HashMap<>();
            conv.put("partner", partner);
            conv.put("messages", thread);
            conv.put("lastMessage", thread.isEmpty() ? null : thread.get(thread.size() - 1));
            conversations.add(conv);
        }

        String partnerIdStr = req.getParameter("with");
        if (partnerIdStr != null) {
            int partnerId = Integer.parseInt(partnerIdStr);
            ds.markConversationRead(userId, partnerId);
            req.setAttribute("activePartnerId", partnerId);
            req.setAttribute("activeThread", ds.getConversation(userId, partnerId));
            req.setAttribute("activePartner", ds.getUserById(partnerId));
        }

        req.setAttribute("conversations", conversations);
        req.setAttribute("allUsers", ds.getAllUsers());
        req.setAttribute("unreadCount", ds.getUnreadCount(userId));
        forward(req, resp, "/messages.jsp");
    }

    private void handleSendMessage(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        int senderId = (int) req.getSession().getAttribute("userId");
        int receiverId = Integer.parseInt(req.getParameter("receiverId"));
        String content = req.getParameter("content");

        ds.sendMessage(senderId, receiverId, content);
        resp.sendRedirect(req.getContextPath() + "/app/messages?with=" + receiverId);
    }

    private void handleSavedEvents(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        int userId = (int) req.getSession().getAttribute("userId");
        List<SavedEvent> saved = ds.getSavedEventsForUser(userId);

        List<Map<String, Object>> enriched = new ArrayList<>();
        for (SavedEvent se : saved) {
            ClubEvent event = ds.getEventById(se.getEventId());
            Club club = ds.getClubById(se.getClubId());
            if (event == null || club == null) continue;
            Map<String, Object> m = new HashMap<>();
            m.put("savedEvent", se);
            m.put("event", event);
            m.put("club", club);
            enriched.add(m);
        }

        req.setAttribute("savedItems", enriched);
        req.setAttribute("allEvents", ds.getAllEvents());

        String msg = req.getParameter("msg");
        if (msg != null) req.setAttribute("flashMsg", msg);

        forward(req, resp, "/savedEvents.jsp");
    }

    private void handleSaveEvent(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        int userId = (int) req.getSession().getAttribute("userId");
        int eventId = Integer.parseInt(req.getParameter("eventId"));
        int clubId  = Integer.parseInt(req.getParameter("clubId"));

        ds.saveEvent(userId, eventId, clubId);
        resp.sendRedirect(req.getContextPath() + "/app/savedEvents?msg=saved");
    }

    private void handleUnsaveEvent(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        int userId  = (int) req.getSession().getAttribute("userId");
        int eventId = Integer.parseInt(req.getParameter("eventId"));

        ds.unsaveEvent(userId, eventId);
        resp.sendRedirect(req.getContextPath() + "/app/savedEvents?msg=removed");
    }

    private void handleCreateEvent(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        int userId = (int) req.getSession().getAttribute("userId");

        int clubId;
        LocalDateTime when;
        try {
            clubId = Integer.parseInt(req.getParameter("clubId"));
            when   = LocalDateTime.parse(req.getParameter("eventDate"));
        } catch (NumberFormatException | DateTimeParseException | NullPointerException ex) {
            resp.sendRedirect(req.getContextPath() + "/app/clubLeaderDashboard?msg=eventBadInput");
            return;
        }

        if (ds.hasEventConflict(clubId, when, null)) {
            resp.sendRedirect(req.getContextPath() + "/app/clubLeaderDashboard?msg=eventConflict");
            return;
        }

        ClubEvent created = ds.createEvent(
                clubId, userId,
                req.getParameter("title"),
                req.getParameter("description"),
                req.getParameter("location"),
                when
        );

        String msg = (created == null) ? "eventDenied" : "eventCreated";
        resp.sendRedirect(req.getContextPath() + "/app/clubLeaderDashboard?msg=" + msg);
    }

    private void handleUpdateEvent(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        int userId = (int) req.getSession().getAttribute("userId");

        int eventId;
        LocalDateTime when;
        try {
            eventId = Integer.parseInt(req.getParameter("eventId"));
            when    = LocalDateTime.parse(req.getParameter("eventDate"));
        } catch (NumberFormatException | DateTimeParseException | NullPointerException ex) {
            resp.sendRedirect(req.getContextPath() + "/app/clubLeaderDashboard?msg=eventBadInput");
            return;
        }

        Club ownerClub = ds.getClubForEvent(eventId);
        if (ownerClub != null && ds.hasEventConflict(ownerClub.getId(), when, eventId)) {
            resp.sendRedirect(req.getContextPath() + "/app/clubLeaderDashboard?msg=eventConflict");
            return;
        }

        boolean ok = ds.updateEvent(
                eventId, userId,
                req.getParameter("title"),
                req.getParameter("description"),
                req.getParameter("location"),
                when
        );

        String msg = ok ? "eventUpdated" : "eventDenied";
        resp.sendRedirect(req.getContextPath() + "/app/clubLeaderDashboard?msg=" + msg);
    }

    private void handleDeleteEvent(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        int userId = (int) req.getSession().getAttribute("userId");

        int eventId;
        try {
            eventId = Integer.parseInt(req.getParameter("eventId"));
        } catch (NumberFormatException | NullPointerException ex) {
            resp.sendRedirect(req.getContextPath() + "/app/clubLeaderDashboard?msg=eventBadInput");
            return;
        }

        boolean ok = ds.deleteEvent(eventId, userId);
        String msg = ok ? "eventDeleted" : "eventDenied";
        resp.sendRedirect(req.getContextPath() + "/app/clubLeaderDashboard?msg=" + msg);
    }

    private void handleRemoveMember(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        int leaderId = (int) req.getSession().getAttribute("userId");

        int clubId, memberId;
        try {
            clubId   = Integer.parseInt(req.getParameter("clubId"));
            memberId = Integer.parseInt(req.getParameter("memberId"));
        } catch (NumberFormatException | NullPointerException ex) {
            resp.sendRedirect(req.getContextPath() + "/app/clubLeaderDashboard?msg=memberBadInput");
            return;
        }

        boolean ok = ds.removeMember(clubId, memberId, leaderId);
        String msg = ok ? "memberRemoved" : "memberDenied";
        resp.sendRedirect(req.getContextPath() + "/app/clubLeaderDashboard?msg=" + msg);
    }
}