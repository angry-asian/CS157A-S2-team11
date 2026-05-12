package findMyClub;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

/**
 * Mirrors the Users schema from the design report:
 * Users(User_ID, First_Name, Last_Name, Email, Password, Account_Type, Created_At)
 */
public class User {
    private int id;
    private String firstName;
    private String lastName;
    private String email;
    private String password;
    private String role; // "student", "clubLeader", "admin"  (Account_Type)
    private LocalDateTime createdAt;

    /** Canonical constructor — matches the schema columns. */
    public User(int id, String firstName, String lastName,
                String email, String password, String role) {
        this.id = id;
        this.firstName = firstName == null ? "" : firstName;
        this.lastName  = lastName  == null ? "" : lastName;
        this.email = email;
        this.password = password;
        this.role = role;
        this.createdAt = LocalDateTime.now();
    }

    /** Backwards-compatible constructor: accepts a single full-name string,
     *  split on the FIRST whitespace into firstName / lastName. Older callers
     *  (and the seed data) keep working unchanged. */
    public User(int id, String fullName, String email, String password, String role) {
        this(id, splitFirst(fullName), splitRest(fullName), email, password, role);
    }

    private static String splitFirst(String fullName) {
        if (fullName == null) return "";
        String trimmed = fullName.trim();
        int sp = trimmed.indexOf(' ');
        return sp < 0 ? trimmed : trimmed.substring(0, sp);
    }

    private static String splitRest(String fullName) {
        if (fullName == null) return "";
        String trimmed = fullName.trim();
        int sp = trimmed.indexOf(' ');
        return sp < 0 ? "" : trimmed.substring(sp + 1).trim();
    }

    public int getId() { return id; }
    public String getFirstName() { return firstName; }
    public String getLastName() { return lastName; }

    /** Convenience: "First Last", or just "First" if no last name. */
    public String getName() {
        if (lastName == null || lastName.isEmpty()) return firstName;
        return firstName + " " + lastName;
    }

    public String getEmail() { return email; }
    public String getPassword() { return password; }
    public String getRole() { return role; }
    public LocalDateTime getCreatedAt() { return createdAt; }

    public String getFormattedCreatedAt() {
        if (createdAt == null) return "";
        return createdAt.format(DateTimeFormatter.ofPattern("MMM d, yyyy"));
    }

    public void setFirstName(String firstName) { this.firstName = firstName == null ? "" : firstName; }
    public void setLastName(String lastName)   { this.lastName  = lastName  == null ? "" : lastName; }

    /** Accepts a full name and splits it. Kept for callers that still pass a single string. */
    public void setName(String fullName) {
        this.firstName = splitFirst(fullName);
        this.lastName  = splitRest(fullName);
    }

    public void setEmail(String email) { this.email = email; }
    public void setPassword(String password) { this.password = password; }
    public void setRole(String role) { this.role = role; }
}
