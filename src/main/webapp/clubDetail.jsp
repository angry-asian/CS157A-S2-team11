<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="findMyClub.MembershipRequest" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>${club.name} — FindMyClub</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/style/styling.css">
</head>
<body>

<nav class="navbar">
    <a class="nav-brand" href="${pageContext.request.contextPath}/app/search">Find<span>My</span>Club</a>
    <div class="nav-links">
        <% if (session.getAttribute("userId") != null) { %>
            <% if ("admin".equals(session.getAttribute("userRole"))) { %>
                <a href="${pageContext.request.contextPath}/app/adminDashboard">🛡️ Admin Panel</a>
            <% } else if ("clubLeader".equals(session.getAttribute("userRole"))) { %>
                <a href="${pageContext.request.contextPath}/app/clubLeaderDashboard">My Dashboard</a>
            <% } else { %>
                <a href="${pageContext.request.contextPath}/app/studentDashboard">My Dashboard</a>
            <% } %>
            <a href="${pageContext.request.contextPath}/app/messages">💬 Messages</a>
            <a href="${pageContext.request.contextPath}/app/savedEvents">⭐ Saved Events</a>
            <span class="nav-user">👋 ${sessionScope.userName}</span>
            <a href="${pageContext.request.contextPath}/app/logout">Log Out</a>
        <% } else { %>
            <a href="${pageContext.request.contextPath}/app/login">Sign In</a>
            <a href="${pageContext.request.contextPath}/app/register" class="nav-pill">Register</a>
        <% } %>
    </div>
</nav>

<div class="club-detail-header">
    <div class="breadcrumb"><a href="${pageContext.request.contextPath}/app/search">← All Clubs</a></div>
    <span class="badge">${club.category}</span>
    <h1 style="margin-top:.5rem">${club.name}</h1>
    <p style="color:var(--gray-300);margin-top:.4rem;max-width:700px;">${club.description}</p>
</div>

<div class="container">
    <c:if test="${flashMsg == 'requested'}">
        <div class="alert alert-success mt-2">✅ Membership request submitted!</div>
    </c:if>
    <c:if test="${flashMsg == 'cancelled'}">
        <div class="alert alert-info mt-2">Request cancelled.</div>
    </c:if>
    <c:if test="${flashMsg == 'alreadyRequested'}">
        <div class="alert alert-warning mt-2">You already have a pending request for this club.</div>
    </c:if>

    <div class="detail-grid">
        <div>
            <div class="detail-card">
                <h3>Club Details</h3>
                <div class="info-row"><span>📍</span><div><strong>Location</strong><br>${club.meetingLocation}</div></div>
                <div class="info-row"><span>🕐</span><div><strong>Meets</strong><br>${club.meetingTime}</div></div>
                <div class="info-row"><span>💬</span><div><strong>Communication</strong><br>${club.communicationPlatform}</div></div>
                <div class="info-row"><span>👥</span><div><strong>Members</strong><br>${club.memberCount} students</div></div>
                <c:if test="${leader != null}">
                    <div class="info-row"><span>🏅</span><div><strong>Club Leader</strong><br>${leader.name}</div></div>
                </c:if>
            </div>

            <c:if test="${not empty club.keywords}">
                <div class="detail-card">
                    <h3>Keywords</h3>
                    <div style="margin-top:.3rem">
                        <c:forEach var="kw" items="${club.keywords}">
                            <span class="tag">${kw}</span>
                        </c:forEach>
                    </div>
                </div>
            </c:if>
        </div>

        <div>
            <div class="detail-card">
                <h3>Membership</h3>
                <% Boolean isMember = (Boolean) request.getAttribute("isMember");
                   MembershipRequest myReq = (MembershipRequest) request.getAttribute("myRequest"); %>

                <% if (session.getAttribute("userId") == null) { %>
                    <p class="text-muted">Sign in to request membership.</p>
                    <a href="${pageContext.request.contextPath}/app/login" class="btn-gold mt-2">Sign In to Join</a>
                <% } else if (isMember != null && isMember) { %>
                    <div class="alert alert-success">✅ You are a member!</div>
                <% } else if (myReq != null && "pending".equals(myReq.getStatus())) { %>
                    <div class="alert alert-warning">⏳ Request pending review.</div>
                    <form action="${pageContext.request.contextPath}/app/cancelRequest" method="post" style="margin-top:.8rem">
                        <input type="hidden" name="requestId" value="${myReq.id}">
                        <input type="hidden" name="clubId"    value="${club.id}">
                        <button type="submit" class="btn-danger btn-sm">Cancel Request</button>
                    </form>
                <% } else if (myReq != null && "rejected".equals(myReq.getStatus())) { %>
                    <div class="alert alert-danger">❌ Previous request was not approved.</div>
                <% } else { %>
                    <p class="text-muted" style="margin-bottom:.9rem;">Interested in joining?</p>
                    <form action="${pageContext.request.contextPath}/app/joinRequest" method="post">
                        <input type="hidden" name="clubId" value="${club.id}">
                        <button type="submit" class="btn-gold">Request to Join</button>
                    </form>
                <% } %>
            </div>

            <div class="detail-card">
                <h3>Upcoming Events</h3>
                <c:choose>
                    <c:when test="${empty club.events}">
                        <p class="text-muted">No upcoming events.</p>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="event" items="${club.events}">
                            <div class="event-item">
                                <div class="event-title">📌 ${event.title}</div>
                                <div class="event-meta">📅 ${event.formattedDate}</div>
                                <div class="event-meta">📍 ${event.location}</div>
                                <div style="font-size:.85rem;color:var(--gray-700);margin-top:.3rem">${event.description}</div>
                            </div>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</div>
</body>
</html>