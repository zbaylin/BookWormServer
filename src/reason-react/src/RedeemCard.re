type phase =
  | Entry
  | Submission
  | Submitted;

/* Create a type for the expected response */
type response = {
  success: bool,
  message: option(string),
  url: option(string)
};

module Decode = {
  let response = json =>
    Json.Decode.{
      /* The server always sends this */
      success: json |> field("success", bool),
      /* Only shown on error */
      message: json |> optional(field("message", string)),
      /* Only shown on success */
      url: json |> optional(field("url", string))
    };
};

type action =
  | SubmitRedemption
  | UpdatePassword(string)
  | UpdateEmail(string)
  | UpdateRedemptionKey(string)
  | UpdateResponse(response)
  | UpdatePhase(phase);

type state = {
  error: option(string),
  phase: phase,
  email: string,
  password: string,
  redemptionKey: string,
  response: option(response)
};

let component = ReasonReact.reducerComponent("RedeemCard");

/* Convenience function to get the value from a form */
let getFormEventValue = e => ReactDOMRe.domElementToObj(ReactEventRe.Form.target(e))##value;

let make = (children) => {
  ...component,
  initialState: () => {
    error: None,
    phase: Entry,
    email: "",
    password: "",
    redemptionKey: "",
    response: None
  },
  reducer: (action : action, state : state) => switch action {
    | SubmitRedemption => ReasonReact.SideEffects((self) => {
      /* Creates an empty payload to be sent to the server */
      let payload = Js.Dict.empty();

      /* Sets the properties of the payload to the values */
      payload -> Js.Dict.set("email", Js.Json.string(state.email))
      payload -> Js.Dict.set("password", Js.Json.string(state.password))
      payload -> Js.Dict.set("redemption_key", Js.Json.string(state.redemptionKey))

      self.send(UpdatePhase(Submission));

      Js.Promise.(
        Fetch.fetchWithInit(
          "/api/issuance/redeem",
          Fetch.RequestInit.make(
            ~method_=Post,
            ~body=Fetch.BodyInit.make(Js.Json.stringify(Js.Json.object_(payload))),
            ~headers=Fetch.HeadersInit.make({"Content-Type": "application/json"}),
            ()
          )
        ) |> then_(Fetch.Response.json)
          |> then_((json) => {
              let response = json |> Decode.response;
              self.send(UpdateResponse(response));
              self.send(UpdatePhase(Submitted));
              () |> resolve;
            }
          ) |> resolve
      ) |> ignore;
    })
    | UpdateEmail(email) => ReasonReact.Update({...state, email})
    | UpdatePassword(password) => ReasonReact.Update({...state, password})
    | UpdateRedemptionKey(redemptionKey) => ReasonReact.Update({...state, redemptionKey})
    | UpdatePhase(phase) => ReasonReact.Update({...state, phase})
    | UpdateResponse(response) => ReasonReact.Update({...state, response: Some(response)})
  },
  render: self => {
    <div className="card card-shadow-animated">
      <div className="card-header">
        <div className="card-image">
          <img className="img-responsive" src="/img/full_logo.svg"/>
        </div>
        <div className="card-title">
          <p className="h4 has-text-centered">(ReasonReact.string("Redeem"))</p>
          <p className="has-text-centered">(ReasonReact.string("Please enter your information in the fields below."))</p>
        </div>
      </div>
      <div className="card-body">
        (switch self.state.phase {
          | Entry => 
            <div>
              <div className="form-group">
                <label className="form-label">(ReasonReact.string("Email"))</label>
                <input 
                  className="form-input"
                  type_="text"
                  value=self.state.email
                  id="email-input" 
                  placeholder="ex. john@smith.com"
                  onChange=((evt) => {
                    let email = evt -> getFormEventValue;
                    self.send(UpdateEmail(email))
                  })/>
                
                <label className="form-label">(ReasonReact.string("Password"))</label>
                <input 
                  className="form-input"
                  type_="password"
                  value=self.state.password
                  id="password-input"
                  onChange=((evt) => {
                    let password = evt -> getFormEventValue;
                    self.send(UpdatePassword(password))
                  })
                  />

                <label className="form-label">(ReasonReact.string("Redemption Code"))</label>
                <input 
                  className="form-input"
                  type_="text"
                  value=self.state.redemptionKey
                  id="redemption-key-input" 
                  placeholder="ex. 1a2B3c"
                  onChange=((evt) => {
                    let redemptionKey = evt -> getFormEventValue;
                    self.send(UpdateRedemptionKey(redemptionKey))
                  })
                  />
              </div>
              <button
                className="btn btn-primary btn-block"
                onClick=((_) => self.send(SubmitRedemption))
                >
                (ReasonReact.string("Submit"))
              </button>
            </div>
          | Submission => 
            <div>
              <div className="loading loading-lg"/>
            </div>
          | Submitted => switch (Belt.Option.getExn(self.state.response)) {
            /* When it's not successful, show an error message */
            | {
                success: false,
                message: Some(x),
                url: None
              } => <p className="text-error has-text-centered">(ReasonReact.string("Uh oh! " ++ x))</p>
            /* When it is successful, show a link to the URL */
            | {
                success: true,
                message: None,
                url: Some(url)
              } => <a 
                     className="has-text-centered"
                     href=("/issuance/download/" ++ url)
                     >
                     (ReasonReact.string("Please click this link to download your eBook."))
                    </a>
            /* This scenario shouldn't happen, but if it does, show an empy container */
            | _ => <div/>
          }
        })
      </div>
    </div>
  }
}   