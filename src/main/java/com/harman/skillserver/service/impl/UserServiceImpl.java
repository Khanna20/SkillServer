package com.harman.skillserver.service.impl;

import org.springframework.beans.factory.annotation.Autowired;

import com.harman.skillserver.beans.AccessTokenUpdate;
import com.harman.skillserver.dao.UserDao;
import com.harman.skillserver.exceptions.DatabaseException;
import com.harman.skillserver.model.LoginModel;
import com.harman.skillserver.model.User;
import com.harman.skillserver.service.UserService;
import org.apache.log4j.Logger;

public class UserServiceImpl implements UserService {
	private static final Logger LOGGER = Logger.getLogger(UserServiceImpl.class);
	@Autowired
	UserDao userDao;

	@Override
	public void addNewUser(User user) {
		try {
			userDao.register(user);
		} catch (DatabaseException ex) {
			LOGGER.error(" Error is : " + ex.getMessage(), ex);
			throw new DatabaseException(ex.getMessage(), ex.getCause());

		}
	}

	@Override
	public User validateUser(LoginModel login) {
		try {
			return userDao.validateUser(login);
		} catch (DatabaseException ex) {
			LOGGER.error(" Error is : " + ex.getMessage(), ex);
			throw new DatabaseException(ex.getMessage(), ex.getCause());
		}
	}

	@Override
	public void updateAccessToken(AccessTokenUpdate tokenUpdate) {
		try {
			userDao.updateAccessToken(tokenUpdate);
		} catch (DatabaseException ex) {
			LOGGER.error(" Error is : " + ex.getMessage(), ex);
			throw new DatabaseException(ex.getMessage(), ex.getCause());
		}

	}

}
