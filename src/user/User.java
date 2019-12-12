package user;

public class User {
	
	private String userID;
	private String userPassword;
	private String userGameID;
	private String userEmail;
	private boolean userEmailChecked;
	
	public String getUserEmail() {
		return userEmail;
	}
	public void setUserEmail(String userEmail) {
		this.userEmail = userEmail;
	}
	public boolean isUserEmailChecked() {
		return userEmailChecked;
	}
	public void setUserEmailChecked(boolean userEmailChecked) {
		this.userEmailChecked = userEmailChecked;
	}
	public String getUserID() {
		return userID;
	}
	public void setUserID(String userID) {
		this.userID = userID;
	}
	public String getUserPassword() {
		return userPassword;
	}
	public void setUserPassword(String userPassword) {
		this.userPassword = userPassword;
	}
	public String getUserGameID() {
		return userGameID;
	}
	public void setUserGameID(String userGameID) {
		this.userGameID = userGameID;
	}
}
