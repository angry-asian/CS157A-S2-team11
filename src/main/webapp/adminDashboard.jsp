<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard — FindMyClub</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/style/styling.css">
    <style>
        .admin-tabs { display:flex; gap:.5rem; margin-bottom:1.5rem; flex-wrap:wrap; }
        .tab-btn {
            padding:.55rem 1.2rem; border:2px solid var(--navy); border-radius:8px;
            background:transparent; color:var(--navy); font-weight:600; cursor:pointer;
            font-family:'DM Sans',sans-serif; font-size:.9rem; transition:.15s;
        }
        .tab-btn.active, .tab-btn:hover { background:var(--navy); color:#fff; }
        .tab-panel { display:none; }
        .tab-panel.active { display:block; }

        .stat-row { display:flex; gap:1rem; flex-wrap:wrap; margin-bottom:1.5rem; }
        .stat-card {
            flex:1; min-width:140px; background:#fff; border-radius:var(--radius);
            padding:1rem 1.2rem; box-shadow:var(--shadow); text-align:center;
        }
        .stat-num { font-size:2rem; font-weight:700; color:var(--navy); }
        .stat-label { font-size:.8rem; color:var(--gray-500); margin-top:.2rem; }

        .club-pending-card {
            background:#fff; border-radius:var(--radius); padding:1.2rem 1.4rem;
            margin-bottom:.9rem; box-shadow:var(--shadow);
            border-left:4px solid var(--gold);
        }
        .club-pending-card h3 { margin:0 0 .3rem; font-size:1rem; color:var(--navy); }
        .club-meta { font-size:.82rem; color:var(--gray-500); margin-bottom:.8rem; }
        .action-row { display:flex; gap:.6rem; align-items:center; flex-wrap:wrap; }
        .reject-input {
            flex:1; min-width:200px; padding:.45rem .8rem;
            border:1.5px solid var(--gray-300); border-radius:6px;
            font-family:'DM Sans',sans-serif; font-size:.85rem;
        }

        .users-table { width:100%; border-collapse:collapse; font-size:.88rem; }
        .users-table th {
            background:var(--navy); color:#fff; padding:.65rem 1rem;
            text-align:left; font-weight:600;
        }
        .users-table td { padding:.6rem 1rem; border-bottom:1px solid var(--gray-100); }
        .users-table tr:hover td { background:var(--gray-50); }
        .role-select {
            padding:.35rem .6rem; border:1.5px solid var(--gray-300); border-radius:6px;
            font-family:'DM Sans',sans-serif; font-size:.83rem; color:var(--navy);
        }
        .btn-xs {
            padding:.3rem .7rem; font-size:.78rem; border-radius:6px;
            background:var(--navy); color:#fff; border:none; cursor:pointer;
        }
        .btn-xs:hover { background:var(--navy-mid); }

        .activity-item {
            display:flex; gap:.8rem; align-items:flex-start;
            padding:.75rem 0; border-bottom:1px solid var(--gray-100);
        }
        .activity-icon {
            width:36px; height:36px; border-radius:50%; flex-shrink:0;
            display:flex; align-items:center; justify-content:center;
            font-size:1rem;
        }
        .activity-icon.msg  { background:#EEF2FF; }
        .activity-icon.req  { background:#FEF9EE; }
        .activity-icon.event{ background:#ECFDF5; }
        .activity-text { font-size:.87rem; color:var(--gray-700); }
        .activity-time { font-size:.77rem; color:var(--gray-500); margin-top:.15rem; }
    </style>
</head>
<body>

<nav class="navbar">
    <a class="nav-brand" href="${pageContext.request.contextPath}/app/search">Find<span>My</span>Club</a>
    <div class="nav-links">
        <a href="${pageContext.request.contextPath}/app/adminDashboard">Admin Panel</a>
        <a href="${pageContext.request.contextPath}/app/messages">💬 Messages</a>
        <a href="${pageContext.request.contextPath}/app/search">Browse Clubs</a>
        <span class="nav-user">🛡️ ${sessionScope.userName}</span>
        <a href="${pageContext.request.contextPath}/app/logout">Log Out</a>
    </div>
</nav>

<div class="dash-header">
    <h1>🛡️ Admin Dashboard</h1>
    <p>Manage club approvals, user roles, and monitor system activity.</p>
</div>

<div class="container">

    <c:if test="${not empty flashMsg}">
        <div class="alert alert-success" style="margin-bottom:1rem;">
            <c:choose>
                <c:when test="${flashMsg == 'approved'}">✅ Club approved and is now live.</c:when>
                <c:when test="${flashMsg == 'rejected'}">❌ Club rejected with feedback.</c:when>
                <c:when test="${flashMsg == 'roleUpdated'}">👤 User role updated successfully.</c:when>
                <c:otherwise>Action completed.</c:otherwise>
            </c:choose>
        </div>
    </c:if>

    <!-- Stats Row -->
    <div class="stat-row">
        <div class="stat-card">
            <div class="stat-num">${allUsers.size()}</div>
            <div class="stat-label">Total Users</div>
        </div>
        <div class="stat-card">
            <div class="stat-num">${allClubs.size()}</div>
            <div class="stat-label">Total Clubs</div>
        </div>
        <div class="stat-card">
            <div class="stat-num">${pendingClubs.size()}</div>
            <div class="stat-label">Awaiting Approval</div>
        </div>
        <div class="stat-card">
            <div class="stat-num">${allRequests.size()}</div>
            <div class="stat-label">Membership Requests</div>
        </div>
        <div class="stat-card">
            <div class="stat-num">${allEvents.size()}</div>
            <div class="stat-label">Active Events</div>
        </div>
        <div class="stat-card">
            <div class="stat-num">${allMessages.size()}</div>
            <div class="stat-label">Messages Sent</div>
        </div>
    </div>

    <!-- Tabs -->
    <div class="admin-tabs">
        <button class="tab-btn active" onclick="showTab('pending')">📋 Pending Clubs (${pendingClubs.size()})</button>
        <button class="tab-btn" onclick="showTab('users')">👥 User Management</button>
        <button class="tab-btn" onclick="showTab('activity')">📊 System Activity</button>
        <button class="tab-btn" onclick="showTab('allclubs')">🏛️ All Clubs</button>
    </div>

    <!-- TAB: Pending Club Approvals -->
    <div id="tab-pending" class="tab-panel active">
        <div class="dash-section full-width">
            <h2>📋 Clubs Awaiting Approval</h2>
            <c:choose>
                <c:when test="${empty pendingClubs}">
                    <p class="text-muted">No clubs are currently pending approval.</p>
                </c:when>
                <c:otherwise>
                    <c:forEach var="club" items="${pendingClubs}">
                        <div class="club-pending-card">
                            <h3>${club.name}</h3>
                            <div class="club-meta">
                                ${club.category} · ${club.meetingLocation} · ${club.meetingTime}
                            </div>
                            <p style="font-size:.88rem;color:var(--gray-700);margin:.5rem 0 .9rem;">
                                ${club.description}
                            </p>
                            <div class="action-row">
                                <form action="${pageContext.request.contextPath}/app/approveClub" method="post" style="margin:0">
                                    <input type="hidden" name="clubId" value="${club.id}">
                                    <button type="submit" class="btn-gold">✅ Approve</button>
                                </form>
                                <form action="${pageContext.request.contextPath}/app/rejectClub" method="post" style="margin:0;display:flex;gap:.5rem;flex:1;">
                                    <input type="hidden" name="clubId" value="${club.id}">
                                    <input type="text" name="reason" class="reject-input"
                                           placeholder="Rejection reason (optional)…">
                                    <button type="submit" class="btn-danger">❌ Reject</button>
                                </form>
                            </div>
                        </div>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <!-- TAB: User Management -->
    <div id="tab-users" class="tab-panel">
        <div class="dash-section full-width">
            <h2>👥 User Role Management</h2>
            <p class="text-muted" style="margin-bottom:1rem;">
                Assign or revoke roles for any user. Changes take effect immediately.
            </p>
            <div style="overflow-x:auto;">
                <table class="users-table">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Name</th>
                            <th>Email</th>
                            <th>Current Role</th>
                            <th>Change Role</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="u" items="${allUsers}">
                            <tr>
                                <td>${u.id}</td>
                                <td>${u.name}</td>
                                <td style="color:var(--gray-500)">${u.email}</td>
                                <td>
                                    <span class="status-badge status-${u.role}">${u.role}</span>
                                </td>
                                <td>
                                    <form action="${pageContext.request.contextPath}/app/updateUserRole"
                                          method="post" style="margin:0;display:flex;gap:.4rem;">
                                        <input type="hidden" name="userId" value="${u.id}">
                                        <select name="newRole" class="role-select">
                                            <option value="student"    ${u.role == 'student'    ? 'selected' : ''}>Student</option>
                                            <option value="clubLeader" ${u.role == 'clubLeader' ? 'selected' : ''}>Club Leader</option>
                                            <option value="admin"      ${u.role == 'admin'      ? 'selected' : ''}>Admin</option>
                                        </select>
                                </td>
                                <td>
                                        <button type="submit" class="btn-xs">Update</button>
                                    </form>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <!-- TAB: System Activity -->
    <div id="tab-activity" class="tab-panel">
        <div class="dash-grid">

            <div class="dash-section">
                <h2>📨 Recent Membership Requests</h2>
                <c:choose>
                    <c:when test="${empty allRequests}">
                        <p class="text-muted">No requests yet.</p>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="req" items="${allRequests}" begin="0" end="9">
                            <div class="activity-item">
                                <div class="activity-icon req">📋</div>
                                <div>
                                    <div class="activity-text">
                                        Student #${req.studentId} → Club #${req.clubId}
                                    </div>
                                    <div style="margin-top:.2rem;">
                                        <span class="status-badge status-${req.status}">${req.status}</span>
                                    </div>
                                    <div class="activity-time">${req.formattedRequestDate}</div>
                                </div>
                            </div>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </div>

            <div class="dash-section">
                <h2>🎉 Upcoming Club Events</h2>
                <c:choose>
                    <c:when test="${empty allEvents}">
                        <p class="text-muted">No events scheduled.</p>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="event" items="${allEvents}">
                            <div class="activity-item">
                                <div class="activity-icon event">🗓️</div>
                                <div>
                                    <div class="activity-text"><strong>${event.title}</strong></div>
                                    <div class="activity-text">${event.location}</div>
                                    <div class="activity-time">${event.formattedDate}</div>
                                </div>
                            </div>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </div>

            <div class="dash-section full-width">
                <h2>💬 Recent Messages</h2>
                <c:choose>
                    <c:when test="${empty allMessages}">
                        <p class="text-muted">No messages sent yet.</p>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="msg" items="${allMessages}" begin="0" end="9">
                            <div class="activity-item">
                                <div class="activity-icon msg">💬</div>
                                <div>
                                    <div class="activity-text">
                                        User #${msg.senderId} → User #${msg.receiverId}:
                                        <em>${msg.content}</em>
                                    </div>
                                    <div class="activity-time">${msg.formattedDate}</div>
                                </div>
                            </div>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </div>

        </div>
    </div>

    <!-- TAB: All Clubs -->
    <div id="tab-allclubs" class="tab-panel">
        <div class="dash-section full-width">
            <h2>🏛️ All Clubs</h2>
            <div style="overflow-x:auto;">
                <table class="users-table">
                    <thead>
                        <tr>
                            <th>ID</th><th>Name</th><th>Category</th>
                            <th>Members</th><th>Status</th><th>Leader ID</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="club" items="${allClubs}">
                            <tr>
                                <td>${club.id}</td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/app/club?id=${club.id}"
                                       style="color:var(--navy);font-weight:500;">${club.name}</a>
                                </td>
                                <td>${club.category}</td>
                                <td>${club.memberCount}</td>
                                <td><span class="status-badge status-${club.status}">${club.status}</span></td>
                                <td>${club.leaderId}</td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

</div>

<script>
function showTab(name) {
    document.querySelectorAll('.tab-panel').forEach(p => p.classList.remove('active'));
    document.querySelectorAll('.tab-btn').forEach(b => b.classList.remove('active'));
    document.getElementById('tab-' + name).classList.add('active');
    event.target.classList.add('active');
}
</script>

</body>
</html>
