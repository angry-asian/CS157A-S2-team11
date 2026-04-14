package findMyClub;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
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
                resp.sendRedirect(req.getContextPath() + "/app/search");
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
}