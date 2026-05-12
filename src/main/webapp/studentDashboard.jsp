<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    String role = (String) session.getAttribute("userRole");
    if ("admin".equals(role)) {
        response.sendRedirect(request.getContextPath() + "/app/adminDashboard");
        return;
    }
    if ("clubLeader".equals(role)) {
        response.sendRedirect(request.getContextPath() + "/app/clubLeaderDashboard");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>My Dashboard — FindMyClub</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/style/styling.css">
</head>
<body>

<nav class="navbar">
    <a class="nav-brand" href="${pageContext.request.contextPath}/app/search">Find<span>My</span>Club</a>
    <div class="nav-links">
        <a href="${pageContext.request.contextPath}/app/search">Browse Clubs</a>
        <a href="${pageContext.request.contextPath}/app/savedEvents">⭐ Saved Events</a>
        <a href="${pageContext.request.contextPath}/app/messages">💬 Messages</a>
        <span class="nav-user">👋 ${sessionScope.userName}</span>
        <a href="${pageContext.request.contextPath}/app/logout">Log Out</a>
    </div>
</nav>

<div class="dash-header">
    <h1>Student Dashboard</h1>
    <p>Welcome back, ${sessionScope.userName}! Manage your clubs and requests here.</p>
</div>

<div class="container">
    <div class="dash-grid">

        <!-- My Clubs Section -->
        <div class="dash-section">
            <h2>🎓 My Clubs</h2>
            <c:choose>
                <c:when test="${empty myClubs}">
                    <p class="text-muted">You haven't joined any clubs yet.</p>
                    <a href="${pageContext.request.contextPath}/app/search" class="btn-gold mt-2">Browse Clubs</a>
                </c:when>
                <c:otherwise>
                    <c:forEach var="club" items="${myClubs}">
                        <div class="request-row">
                            <div class="request-info">
                                <div class="club-name">${club.name}</div>
                                <div class="req-meta">${club.category} · ${club.meetingTime}</div>
                            </div>
                            <a href="${pageContext.request.contextPath}/app/club?id=${club.id}"
                               class="btn-outline btn-sm">View</a>
                        </div>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- My Requests Section -->
        <div class="dash-section">
            <h2>📋 My Requests</h2>
            <c:choose>
                <c:when test="${empty myRequests}">
                    <p class="text-muted">No membership requests submitted yet.</p>
                </c:when>
                <c:otherwise>
                    <c:forEach var="item" items="${myRequests}">
                        <c:set var="req"  value="${item.request}" />
                        <c:set var="club" value="${item.club}" />
                        <div class="request-row">
                            <div class="request-info">
                                <div class="club-name">${club != null ? club.name : 'Unknown'}</div>
                                <div class="req-meta">Requested ${req.formattedRequestDate}</div>
                            </div>
                            <div style="display:flex;gap:.5rem;align-items:center;">
                                <span class="status-badge status-${req.status}">${req.status}</span>
                                <c:if test="${req.status == 'pending'}">
                                    <form action="${pageContext.request.contextPath}/app/cancelRequest" method="post" style="margin:0">
                                        <input type="hidden" name="requestId" value="${req.id}">
                                        <input type="hidden" name="clubId" value="${req.clubId}">
                                        <button type="submit" class="btn-danger btn-sm"
                                                onclick="return confirm('Cancel this request?')">Cancel</button>
                                    </form>
                                </c:if>
                            </div>
                        </div>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- Discover More Clubs Section -->
        <div class="dash-section full-width">
            <h2>🔍 Discover More Clubs</h2>
            <p class="text-muted" style="margin-bottom:1rem;">Find clubs that match your interests.</p>
            <a href="${pageContext.request.contextPath}/app/search" class="btn-gold">Browse All Clubs</a>
        </div>

    </div>
</div>

</body>
</html>