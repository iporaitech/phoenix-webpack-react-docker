/**
 * file: web/static/js/index.js
 */

import React from 'react';
import ReactDOM from 'react-dom';
import Relay from 'react-relay';
import { Router, Route, IndexRoute, browserHistory, applyRouterMiddleware } from 'react-router'
import useRelay from 'react-router-relay';

// App components
import AdminLayout from 'layout';
import Login from 'login';
import StarWarsApp, { Queries as StarWarsQueries } from 'star_wars/components/StarWarsApp';
import GraphiQL from 'my-graphiql';

// Auth singleton
import Auth from 'lib/auth';

// Just a tmp component for IndexRoute
class Hello extends React.Component {
  render() {
    return(<h1>Hello Public Section</h1>)
  }
}

// function requireAuth(prevState, nextState, replace) {
function requireAuth(nextState, replace) {
  if (!Auth.loggedIn()) {
    replace({
      pathname: "/login",
      state: { nextPathname: nextState.location.pathname }
    })
  }
}

function verifySession(nextState, replace){
  if(Auth.loggedIn())
    replace({ pathname: "/admin" })
}

const routes = (
  <Route path="/">
    <IndexRoute component={Hello}/>
    <Route path="/login" component={Login}  onEnter={verifySession}/>
    <Route path="/admin" component={AdminLayout} onEnter={requireAuth}>
      <IndexRoute component={Hello}/>
      <Route path="star-wars" component={StarWarsApp} queries={StarWarsQueries}/>
      <Route path="graphiql" component={GraphiQL} />
    </Route>
  </Route>
)

class Application extends React.Component{

  constructor(props){
    super(props);
    this.state = { environment: Auth.getEnvironment() };
    Auth.onLogout = ()=> this.handleLogout();
  }

  handleLogout(){
    this.setState({ environment: Auth.getEnvironment() })
  }

  render(){
    return (
      <Router history={browserHistory}
        render={applyRouterMiddleware(useRelay)}
        environment={this.state.environment}>
        {routes}
      </Router>
    );
  }
}

ReactDOM.render(
  <Application/>,
  document.getElementById('react-root')
);
