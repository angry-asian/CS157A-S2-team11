package findMyClub;

import at.favre.lib.crypto.bcrypt.BCrypt;

public class PasswordUtil {

    public static String hash(String plainPassword) {
        return BCrypt.withDefaults().hashToString(12, plainPassword.toCharArray());
    }

    public static boolean verify(String plainPassword, String storedPassword) {
        if (storedPassword == null) return false;

        if (!storedPassword.startsWith("$2")) {
            return plainPassword.equals(storedPassword);
        }

        BCrypt.Result result = BCrypt.verifyer()
            .verify(plainPassword.toCharArray(), storedPassword);

        return result.verified;
    }
}