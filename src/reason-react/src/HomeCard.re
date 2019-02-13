open Webapi.Dom;

/* A predefined list of menu options */
type choice =
  | Redeem
  | Download;


type action =
  | ChooseChoice(choice)
  | UpdateChoice(choice);

type state = {
  chosenChoice: option(choice)
};

let component = ReasonReact.reducerComponent("HomeCard");

let make = (children) => {
  ...component,
  initialState: () => {
    chosenChoice: None
  },
  reducer: (action : action, state : state) => switch action {
    | ChooseChoice(choice) => ReasonReact.SideEffects((self) => {
        self.send(UpdateChoice(choice));
        switch choice {
          | Redeem => window -> Window.setLocation("/issuance/redeem");
          | Download => window -> Window.setLocation("/download");
        }
      })
    | UpdateChoice(choice) => ReasonReact.Update({...state, chosenChoice: Some(choice)})
  },
  render: self => {
    <div className="card card-shadow-animated">
      <div className="card-header">
        <div className="card-image">
          <img className="img-responsive" src="/img/full_logo.svg"/>
        </div>
        <div className="card-title">
          <p className="h4 has-text-centered">(ReasonReact.string("Welcome to BookWorm"))</p>
          <p className="has-text-centered">(ReasonReact.string("Please choose a menu option from the list below. "))</p>
        </div>
      </div>
      <div className="card-body">
        <button 
          className="btn btn-row btn-link menu-button btn-block"
          onClick=((_) => self.send(ChooseChoice(Redeem)))
          >
          (ReasonReact.string("Redeem Book"))</button>
        <button
          className="btn btn-row btn-link menu-button btn-block"
          onClick=((_) => self.send(ChooseChoice(Download)))
          >
          (ReasonReact.string("Download"))</button>
      </div>
    </div>
  }
}