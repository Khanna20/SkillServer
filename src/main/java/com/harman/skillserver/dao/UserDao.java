package com.harman.skillserver.dao;

import com.harman.skillserver.beans.AccessTokenUpdate;
import com.harman.skillserver.model.LoginModel;
import com.harman.skillserver.model.User;

public interface UserDao {

	void register(User user);

	User validateUser(LoginModel login);
	
	void updateAccessToken(AccessTokenUpdate tokenUpdate);

}
