package com.example.appexam1.data;

import android.content.Context;
import android.widget.Toast;

import com.example.appexam1.data.model.LoggedInUser;

import java.io.IOException;
import java.util.ArrayList;

/**
 * Class that handles authentication w/ login credentials and retrieves user information.
 */
public class LoginDataSource {

    public static ArrayList<LoggedInUser> pseudoAuthenticated;

    public Result<LoggedInUser> login(String username, String password) {
        pseudoAuthenticated = new ArrayList<>();
            try {
                // TODO: handle loggedInUser authentication
                LoggedInUser fakeUser =
                        new LoggedInUser(
                                java.util.UUID.randomUUID().toString(),
                                username);
                pseudoAuthenticated.add(fakeUser);
                return new Result.Success<>(fakeUser);
            } catch (Exception e) {
                return new Result.Error(new IOException("Error logging in", e));
            }
    }

    public void addUser(LoggedInUser usr) {
        pseudoAuthenticated.add(usr);
    }

    public void logout(LoggedInUser usr) {
        pseudoAuthenticated.remove(usr);
    }
}