var Entities = require('html-entities').AllHtmlEntities,
  Q = require('q'),
  request = require('request');

var entities = new Entities();
var sessionCookies;

function getIdentity(repo, cookieJar) {
  var deferred = Q.defer();

  var options = {
    url: repo + 'authenticated/identity',
    jar: cookieJar,
    strictSSL: false
  };

  request.get(options, function(err, res) {
    if (err) {
      return deferred.reject(err);
    }

    if (res.statusCode !== 200) {
      return deferred.reject(new Error('bad status: ' + res.statusCode));
    }

    return deferred.resolve();
  });

  return deferred.promise;
}

function postLogin(user, pass, repo, cookieJar) {
  var deferred = Q.defer();

  var options = {
    url: repo + 'auth/j_security_check',
    jar: cookieJar,
    form: {
      j_username: user,
      j_password: pass,
    },
    strictSSL: false
  };

  request.post(options, function(err, res) {
    if (err) {
      return deferred.reject(err);
    }

    if (res.statusCode !== 302 && res.statusCode !== 200) {
      return deferred.reject(new Error('bad status: ' + res.statusCode));
    }

    return deferred.resolve(cookieJar);
  });

  return deferred.promise;
}

function createSession(user, pass, repo) {
  var cookieJar = request.jar();

  return getIdentity(repo, cookieJar)
    .then(function() {
      return postLogin(user, pass, repo, cookieJar);
    })
    .then(function() {
      return getIdentity(repo, cookieJar);
    })
    .then(function() {
      return cookieJar;
    });
}

function getSession(user, pass, repo) {
  if (sessionCookies) {
    return Q(sessionCookies);
  }

  return createSession(user, pass, repo)
    .then(function(cookieJar) {
      sessionCookies = cookieJar;
      return sessionCookies;
    });
}

function getWorkItem(id, cookieJar, repo) {
  var deferred = Q.defer();

  var url = repo + 'service/' +
    'com.ibm.team.workitem.common.internal.rest.IWorkItemRestService/' +
    'workItemDTO2?includeHistory=false&id=' + id;

  var options = {
    url: url,
    jar: cookieJar,
    headers: {
      'X-com-ibm-team-configuration-versions': 'LATEST',
      accept: 'text/json'
    },
    strictSSL: false
  };

  request.get(options, function(err, res, body) {
    if (err) {
      return deferred.reject(err);
    }

    if (res.statusCode !== 200) {
      return deferred.reject(new Error('bad status: ' + res.statusCode));
    }

    return deferred.resolve(body);
  });

  return deferred.promise.then(JSON.parse);
}

function getAttribute(attributes, key) {
  var value;

  attributes.forEach(function(attribute) {
    if (attribute.key === key) {
      value = attribute.value;
    }
  });

  if (!value) {
    throw new Error('No ' + key + ' attribute found');
  }

  return value;
}

function getSummary(id, result) {
  var attributes;

  try {
    attributes = result['soapenv:Body'].response.returnValue.value.attributes;
  } catch (err) {
    throw new Error('Work item not found');
  }
  
  var summary = getAttribute(attributes, 'summary');
  var type = getAttribute(attributes, 'workItemType');

  var description = type.label + ' ' + id + ': ';

  if (summary.isHtml) {
    description += entities.decode(summary.content);
  } else {
    description += summary.content;
  }

  return description;
}

module.exports = function(id, user, pass, repo) {
  return getSession(user, pass, repo)
    .then(function(cookieJar) {
      return getWorkItem(id, cookieJar, repo);
    })
    .fail(function(err) {
      sessionCookies = undefined;
      return getSession(user, pass, repo)
        .then(function(cookieJar) {
          return getWorkItem(id, cookieJar, repo);
        });
    })
    .then(function(result) {
      return getSummary(id, result);
    });
};
