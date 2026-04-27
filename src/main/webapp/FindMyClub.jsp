<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>FindMyClub — Discover Campus Clubs</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/style/styling.css">
</head>
<body>

<nav class="navbar">
    <a class="nav-brand" href="${pageContext.request.contextPath}/app/search">
        Find<span>My</span>Club
    </a>
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

<div class="hero">
    <h1>Find Your <em>Perfect</em> Club</h1>
    <p>Explore every student organization on campus — all in one place.</p>
    <form action="${pageContext.request.contextPath}/app/search" method="get" class="search-bar">
        <input type="text" name="q" placeholder="Search by name, keyword, or category…"
               value="${not empty query ? query : ''}">
        <button type="submit">Search</button>
    </form>
</div>

<form action="${pageContext.request.contextPath}/app/search" method="get">
    <input type="hidden" name="q" value="${not empty query ? query : ''}">
    <div class="filters">
        <label>Category:</label>
        <select name="category">
            <option value="All">All Categories</option>
            <c:forEach var="cat" items="${categories}">
                <option value="${cat}" ${cat == selectedCategory ? 'selected' : ''}>${cat}</option>
            </c:forEach>
        </select>

        <label>Sort by:</label>
        <select name="sort">
            <option value="name" ${sortBy == 'name' ? 'selected' : ''}>Name (A–Z)</option>
            <option value="size" ${sortBy == 'size' ? 'selected' : ''}>Most Members</option>
        </select>

        <button type="submit" class="filter-btn">Apply</button>
        <a href="${pageContext.request.contextPath}/app/search"
           style="font-size:.85rem;color:var(--gray-500);text-decoration:none;">Clear</a>
    </div>
</form>

<div class="container">
    <p class="results-count">Showing <strong>${clubs.size()}</strong> club(s)</p>

    <c:choose>
        <c:when test="${empty clubs}">
            <div class="empty-state">
                <h3>No clubs found</h3>
                <p>Try a different search term or clear the filters.</p>
            </div>
        </c:when>
        <c:otherwise>
            <div class="club-grid">
                <c:forEach var="club" items="${clubs}">
                    <a class="club-card" href="${pageContext.request.contextPath}/app/club?id=${club.id}">
                        <div class="club-card-header">
                            <span class="club-cat-badge">${club.category}</span>
                            <h3>${club.name}</h3>
                        </div>
                        <div class="club-card-body">
                            <p>${club.description}</p>
                        </div>
                        <div class="club-meta">
                            <span class="meta-item">📅 ${club.meetingTime}</span>
                            <span class="meta-item"><strong>${club.memberCount}</strong> members</span>
                        </div>
                    </a>
                </c:forEach>
            </div>
        </c:otherwise>
    </c:choose>
</div>

</body>
</html>