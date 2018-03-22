package com.harman.skillserver.service;

import org.springframework.stereotype.Service;

import com.harman.skillserver.beans.AccessTokenUpdate;
import com.harman.skillserver.model.LoginModel;
import com.harman.skillserver.model.User;


@Service
public interface UserService {

	void addNewUser(User user);
	
	User validateUser(LoginModel login);
	
	void updateAccessToken(AccessTokenUpdate tokenUpdate);

}
