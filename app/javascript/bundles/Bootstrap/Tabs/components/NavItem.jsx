import PropTypes from 'prop-types';
import React from 'react';

export default class NavItem extends React.Component {
  static propTypes = {
    name: PropTypes.string.isRequired, // this is passed from the Rails view
  };

  /**
   * @param props - Comes from your rails view.
   */
  constructor(props) {
    super(props);

    // How to set initial state in ES6 class syntax
    // https://reactjs.org/docs/state-and-lifecycle.html#adding-local-state-to-a-class
    this.state = { name: this.props.name };
  }

  updateName = (name) => {
    this.setState({ name });
  };

  render() {
    return (
      
      <ul className="nav nav-pills mb-3" id="pills-departamentos-tab" role="tablist">
        <li className="nav-item">
          <a data-toggle="tab" className="nav-link show" href="#">{this.state.name}</a>
        </li>
      </ul>
    );
  }
}
