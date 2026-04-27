<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Saved Events — FindMyClub</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/style/styling.css">
    <style>
        .events-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 1.1rem;
        }
        .event-card {
            background: #fff;
            border-radius: var(--radius);
            box-shadow: var(--shadow);
            padding: 1.2rem 1.4rem;
            border-top: 4px solid var(--gold);
            display: flex;
            flex-direction: column;
            gap: .5rem;
        }
        .event-title {
            font-weight: 700;
            color: var(--navy);
            font-size: 1rem;
        }
        .event-club {
            font-size: .82rem;
            color: var(--gray-500);
            font-weight: 500;
        }
        .event-meta {
            display: flex;
            gap: .5rem;
            flex-wrap: wrap;
            font-size: .82rem;
            color: var(--gray-700);
            margin-top: .2rem;
        }
        .event-meta span {
            background: var(--gray-100);
            padding: .2rem .6rem;
            border-radius: 20px;
        }
        .event-desc {
            font-size: .86rem;
            color: var(--gray-700);
            line-height: 1.5;
        }
        .event-actions { display:flex; gap:.6rem; margin-top:.5rem; }

        /* Browse all events panel */
        .browse-section {
            background: #fff;
            border-radius: var(--radius);
            box-shadow: var(--shadow);
            padding: 1.4rem 1.6rem;
            margin-bottom: 2rem;
        }
        .event-browse-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: .8rem 0;
            border-bottom: 1px solid var(--gray-100);
            gap: 1rem;
        }
        .event-browse-row:last-child { border-bottom: none; }
        .event-browse-info { flex: 1; }
        .event-browse-name { font-weight: 600; color: var(--navy); }
        .event-browse-meta { font-size: .81rem; color: var(--gray-500); margin-top: .1rem; }
    </style>
</head>
<body>

<nav class="navbar">
    <a class="nav-brand" href="${pageContext.request.contextPath}/app/search">Find<span>My</span>Club</a>
    <div class="nav-links">
        <c:choose>
            <c:when test="${sessionScope.userRole == 'admin'}">
                <a href="${pageContext.request.contextPath}/app/adminDashboard">Admin Panel</a>
            </c:when>
            <c:when test="${sessionScope.userRole == 'clubLeader'}">
                <a href="${pageContext.request.contextPath}/app/clubLeaderDashboard">My Clubs</a>
            </c:when>
            <c:otherwise>
                <a href="${pageContext.request.contextPath}/app/studentDashboard">Dashboard</a>
            </c:otherwise>
        </c:choose>
        <a href="${pageContext.request.contextPath}/app/messages">💬 Messages</a>
        <a href="${pageContext.request.contextPath}/app/search">Browse Clubs</a>
        <span class="nav-user">⭐ ${sessionScope.userName}</span>
        <a href="${pageContext.request.contextPath}/app/logout">Log Out</a>
    </div>
</nav>

<div class="dash-header">
    <h1>⭐ Saved Events</h1>
    <p>Bookmark club events you don't want to miss.</p>
</div>

<div class="container">

    <c:if test="${not empty flashMsg}">
        <div class="alert alert-success" style="margin-bottom:1.2rem;">
            <c:choose>
                <c:when test="${flashMsg == 'saved'}">✅ Event saved to your list!</c:when>
                <c:when test="${flashMsg == 'removed'}">🗑️ Event removed from saved list.</c:when>
                <c:otherwise>Done.</c:otherwise>
            </c:choose>
        </div>
    </c:if>

    <!-- My Saved Events -->
    <div style="margin-bottom:2rem;">
        <h2 style="margin-bottom:1rem;">📌 My Saved Events</h2>
        <c:choose>
            <c:when test="${empty savedItems}">
                <div class="dash-section" style="text-align:center;padding:2rem;">
                    <p style="color:var(--gray-500);margin-bottom:1rem;">
                        You haven't saved any events yet. Browse upcoming events below!
                    </p>
                </div>
            </c:when>
            <c:otherwise>
                <div class="events-grid">
                    <c:forEach var="item" items="${savedItems}">
                        <c:set var="event" value="${item.event}" />
                        <c:set var="club"  value="${item.club}" />
                        <div class="event-card">
                            <div class="event-title">${event.title}</div>
                            <div class="event-club">🏛️ ${club.name}</div>
                            <div class="event-meta">
                                <span>📍 ${event.location}</span>
                                <span>📅 ${event.formattedDate}</span>
                            </div>
                            <div class="event-desc">${event.description}</div>
                            <div class="event-actions">
                                <a href="${pageContext.request.contextPath}/app/club?id=${club.id}"
                                   class="btn-outline btn-sm">View Club</a>
                                <form action="${pageContext.request.contextPath}/app/unsaveEvent"
                                      method="post" style="margin:0;">
                                    <input type="hidden" name="eventId" value="${event.id}">
                                    <button type="submit" class="btn-danger btn-sm"
                                            onclick="return confirm('Remove this event from saved?')">
                                        🗑️ Remove
                                    </button>
                                </form>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- Browse All Upcoming Events -->
    <div class="browse-section">
        <h2 style="margin-bottom:1rem;">🗓️ All Upcoming Events</h2>
        <c:choose>
            <c:when test="${empty allEvents}">
                <p class="text-muted">No events are scheduled at this time.</p>
            </c:when>
            <c:otherwise>
                <c:forEach var="event" items="${allEvents}">
                    <div class="event-browse-row">
                        <div class="event-browse-info">
                            <div class="event-browse-name">${event.title}</div>
                            <div class="event-browse-meta">
                                📍 ${event.location} · 📅 ${event.formattedDate}
                            </div>
                            <div style="font-size:.82rem;color:var(--gray-700);margin-top:.2rem;">
                                ${event.description}
                            </div>
                        </div>
                        <form action="${pageContext.request.contextPath}/app/saveEvent"
                              method="post" style="margin:0;flex-shrink:0;">
                            <input type="hidden" name="eventId" value="${event.id}">
                            <input type="hidden" name="clubId"  value="${event.clubId}">
                            <button type="submit" class="btn-gold btn-sm">⭐ Save</button>
                        </form>
                    </div>
                </c:forEach>
            </c:otherwise>
        </c:choose>
    </div>

</div>

</body>
</html>
