package user;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class UserDAO {
	// dao : �����ͺ��̽� ���� ��ü�� ���ڷμ�
	// ���������� db���� ȸ������ �ҷ����ų� db�� ȸ������ ������

	private Connection conn; // connection:db�������ϰ� ���ִ� ��ü
	private PreparedStatement pstmt;
	private ResultSet rs;

	// mysql�� ������ �ִ� �κ�
	public UserDAO() { // ������ ����ɶ����� �ڵ����� db������ �̷�� �� �� �ֵ�����
		try {
			String dbURL = "jdbc:mysql://localhost:3306/lol_ledder_db?useUnicode=true&characterEncoding=UTF-8&serverTimezone=UTC"; // localhost:3306
																																	// ��Ʈ��
																																	// ��ǻ�ͼ�ġ��
																																	// mysql�ּ�
			String dbID = "root";
			String dbPassword = "root";
			Class.forName("com.mysql.jdbc.Driver");
			conn = DriverManager.getConnection(dbURL, dbID, dbPassword);
		} catch (Exception e) {
			e.printStackTrace(); // ������ �������� ���
		}
	}

	// �α����� �õ��ϴ� �Լ�****
	public int login(String userID, String userPassword) {
		String SQL = "SELECT userPassword FROM USER WHERE userID = ?";
		try {
			// pstmt : prepared statement ������ sql������ db�� �����ϴ� �������� �ν��Ͻ�������
			pstmt = conn.prepareStatement(SQL);
			// sql������ ���� ��ŷ����� ����ϴ°�... pstmt�� �̿��� �ϳ��� ������ �̸� �غ��ؼ�(����ǥ���)
			// ����ǥ�ش��ϴ� ������ �������̵��, �Ű������� �̿�.. 1)�����ϴ��� 2)��й�ȣ��������
			pstmt.setString(1, userID);
			// rs:result set �� �������
			rs = pstmt.executeQuery();
			// ����� �����Ѵٸ� ����
			if (rs.next()) {
				// �н����� ��ġ�Ѵٸ� ����
				if (rs.getString(1).equals(userPassword)) {
					return 1; // ��� ����
				} else
					return 0; // ��й�ȣ ����ġ
			}
			return -1; // ���̵� ���� ����

		} catch (Exception e) {
			e.printStackTrace();
		}
		return -2; // �����ͺ��̽� ������ �ǹ�
	}

	public int join(User user) {
		String SQL = "INSERT INTO USER VALUES (?, ?, ?, ?, ?)";
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, user.getUserID());
			pstmt.setString(2, user.getUserPassword());
			pstmt.setString(3, user.getUserGameID());
			pstmt.setString(4, user.getUserEmail());
			pstmt.setInt(5, 0);
			return pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1; // �����ͺ��̽� ����
	}
	
	public String getUserEmail(String userID) {
		String SQL = "SELECT userEmail FROM user WHERE userID = ?";
				try {
					pstmt = conn.prepareStatement(SQL);
					pstmt.setString(1, userID);
					rs = pstmt.executeQuery();
					if(rs.next()) {
						return rs.getString(1);
					}
				} catch (Exception e) {
					e.printStackTrace();
				}
				return null;
	}

	public int getUserEmailChecked(String userID) {
		String SQL = "SELECT userEmailChecked FROM user WHERE userID = ?";
				try {
					pstmt = conn.prepareStatement(SQL);
					pstmt.setString(1, userID);
					rs = pstmt.executeQuery();
					if(rs.next()) {
						return rs.getInt(1);
					}
				} catch (Exception e) {
					e.printStackTrace();
				}
				return -1;
	}
	
	public int setUserEmailChecked(String userID) {
		String SQL = "UPDATE user SET userEmailChecked = true WHERE userID = ?";
				try {
					pstmt = conn.prepareStatement(SQL);
					pstmt.setString(1, userID);
					return pstmt.executeUpdate();
				} catch (Exception e) {
					e.printStackTrace();
				}
				return -1;
	}
}