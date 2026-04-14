<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Leader Dashboard — FindMyClub</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/style/styling.css">
</head>
<body>

<nav class="navbar">
    <a class="nav-brand" href="${pageContext.request.contextPath}/app/search">Find<span>My</span>Club</a>
    <div class="nav-links">
        <a href="${pageContext.request.contextPath}/app/search">Browse Clubs</a>
        <span class="nav-user">👋 ${sessionScope.userName}</span>
        <a href="${pageContext.request.contextPath}/app/logout">Log Out</a>
    </div>
</nav>

<div class="dash-header">
    <h1>Club Leader Dashboard</h1>
    <p>Manage your clubs, review membership requests, and update club information.</p>
</div>

<div class="container">
    <!-- Flash Messages -->
    <c:if test="${flashMsg == 'created'}">
        <div class="alert alert-success mt-2">✅ Club created! Pending admin approval.</div>
    </c:if>
    <c:if test="${flashMsg == 'updated'}">
        <div class="alert alert-success mt-2">✅ Club updated successfully.</div>
    </c:if>
    <c:if test="${flashMsg == 'approved'}">
        <div class="alert alert-success mt-2">✅ Membership request approved.</div>
    </c:if>
    <c:if test="${flashMsg == 'rejected'}">
        <div class="alert alert-info mt-2">Request rejected.</div>
    </c:if>

    <div class="dash-grid">

        <!-- My Clubs Section -->
        <div class="dash-section">
            <h2>🏛 My Clubs</h2>
            <c:choose>
                <c:when test="${empty myClubs}">
                    <p class="text-muted">You haven't created any clubs yet.</p>
                </c:when>
                <c:otherwise>
                    <c:forEach var="club" items="${myClubs}">
                        <div class="request-row">
                            <div class="request-info">
                                <div class="club-name">${club.name}</div>
                                <div class="req-meta">${club.category} · ${club.memberCount} members</div>
                            </div>
                            <div style="display:flex;gap:.4rem;align-items:center">
                                <span class="status-badge status-${club.status}">${club.status}</span>
                                <button class="btn-outline btn-sm"
                                        onclick="openEdit(${club.id},'${club.description}','${club.meetingLocation}','${club.meetingTime}','${club.communicationPlatform}')">Edit</button>
                                <a href="${pageContext.request.contextPath}/app/club?id=${club.id}" class="btn-gold btn-sm">View</a>
                            </div>
                        </div>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- Pending Requests Section -->
        <div class="dash-section">
            <h2>📬 Pending Requests
                <c:if test="${not empty pendingRequests}">
                    <span style="background:var(--red);color:#fff;border-radius:20px;padding:.1rem .5rem;font-size:.75rem">${pendingRequests.size()}</span>
                </c:if>
            </h2>
            <c:choose>
                <c:when test="${empty pendingRequests}">
                    <p class="text-muted">No pending requests.</p>
                </c:when>
                <c:otherwise>
                    <c:forEach var="item" items="${pendingRequests}">
                        <c:set var="req" value="${item.request}" />
                        <c:set var="student" value="${item.student}" />
                        <c:set var="club" value="${item.club}" />
                        <div class="request-row" style="flex-direction:column;align-items:flex-start;gap:.5rem">
                            <div>
                                <div class="club-name">${student != null ? student.name : 'Unknown'}</div>
                                <div class="req-meta">Wants to join <strong>${club.name}</strong> · ${req.formattedRequestDate}</div>
                            </div>
                            <div style="display:flex;gap:.5rem">
                                <form action="${pageContext.request.contextPath}/app/processRequest" method="post" style="margin:0">
                                    <input type="hidden" name="requestId" value="${req.id}">
                                    <input type="hidden" name="decision" value="approved">
                                    <button type="submit" class="btn-success btn-sm">✔ Approve</button>
                                </form>
                                <form action="${pageContext.request.contextPath}/app/processRequest" method="post" style="margin:0">
                                    <input type="hidden" name="requestId" value="${req.id}">
                                    <input type="hidden" name="decision" value="rejected">
                                    <button type="submit" class="btn-danger btn-sm">✘ Reject</button>
                                </form>
                            </div>
                        </div>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- Create New Club Section -->
        <div class="dash-section full-width">
            <h2>➕ Create New Club</h2>
            <form action="${pageContext.request.contextPath}/app/createClub" method="post"
                  style="display:grid;grid-template-columns:1fr 1fr;gap:1rem">
                <div class="form-group">
                    <label>Club Name *</label>
                    <input type="text" name="name" placeholder="e.g. Robotics Club" required>
                </div>
                <div class="form-group">
                    <label>Category</label>
                    <select name="category">
                        <c:forEach var="cat" items="${categories}">
                            <option value="${cat}">${cat}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="form-group">
                    <label>Meeting Location</label>
                    <input type="text" name="meetingLocation" placeholder="e.g. Engineering Hall 210">
                </div>
                <div class="form-group">
                    <label>Meeting Time</label>
                    <input type="text" name="meetingTime" placeholder="e.g. Thursdays 5–7 PM">
                </div>
                <div class="form-group">
                    <label>Communication Platform</label>
                    <input type="text" name="communicationPlatform" placeholder="e.g. Discord, Slack">
                </div>
                <div class="form-group" style="grid-column:1/-1">
                    <label>Description</label>
                    <textarea name="description" placeholder="Describe your club's purpose and activities…"></textarea>
                </div>
                <div style="grid-column:1/-1">
                    <button type="submit" class="btn-gold">Submit for Approval</button>
                    <p class="text-muted mt-1">New clubs require admin approval before appearing in search.</p>
                </div>
            </form>
        </div>

    </div>
</div>

<!-- Edit Modal -->
<div class="modal-overlay" id="editModal">
    <div class="modal">
        <h2>Edit Club Info</h2>
        <form action="${pageContext.request.contextPath}/app/updateClub" method="post">
            <input type="hidden" name="clubId" id="editId">
            <div class="form-group">
                <label>Description</label>
                <textarea name="description" id="editDesc"></textarea>
            </div>
            <div class="form-group">
                <label>Meeting Location</label>
                <input type="text" name="meetingLocation" id="editLoc">
            </div>
            <div class="form-group">
                <label>Meeting Time</label>
                <input type="text" name="meetingTime" id="editTime">
            </div>
            <div class="form-group">
                <label>Communication Platform</label>
                <input type="text" name="communicationPlatform" id="editComm">
            </div>
            <div class="modal-actions">
                <button type="button" class="btn-outline" onclick="closeEdit()">Cancel</button>
                <button type="submit" class="btn-gold">Save Changes</button>
            </div>
        </form>
    </div>
</div>

<script>
function openEdit(id, desc, loc, time, comm) {
    document.getElementById('editId').value   = id;
    document.getElementById('editDesc').value = desc;
    document.getElementById('editLoc').value  = loc;
    document.getElementById('editTime').value = time;
    document.getElementById('editComm').value = comm;
    document.getElementById('editModal').classList.add('open');
}

function closeEdit() {
    document.getElementById('editModal').classList.remove('open');
}

document.getElementById('editModal').addEventListener('click', function(e) {
    if (e.target === this) closeEdit();
});
</script>

</body>
</html>