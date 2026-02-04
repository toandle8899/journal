defmodule JournalWeb.AuthLive.Register do
  use JournalWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, page_title: "Register", trigger_submit: false)}
  end

  def handle_event("register", %{"user" => params}, socket) do
    # Trigger form submission to the standard auth route
    {:noreply, assign(socket, trigger_submit: true, params: params)}
  end

  def render(assigns) do
    ~H"""
    <div class="min-h-screen flex items-center justify-center bg-base-300">
      <div class="w-full max-w-md p-8 bg-base-100 rounded-box border border-primary/20 shadow-2xl">
        <h2 class="text-3xl font-display text-primary mb-6 text-center">New Reader</h2>
        
        <form action="/auth/user/password/register" method="post" phx-trigger-action={@trigger_submit} phx-submit="register">
          <input type="hidden" name="_csrf_token" value={get_csrf_token()} />
          <input type="hidden" name="return_to" value="/journals" />
          <div class="form-control mb-4">
            <label class="label text-base-content/80 font-serif">Email</label>
            <input type="email" name="user[email]" required class="input input-bordered focus:border-primary text-base-content bg-base-200" />
          </div>
          
          <div class="form-control mb-4">
            <label class="label text-base-content/80 font-serif">Password</label>
            <input type="password" name="user[password]" required class="input input-bordered focus:border-primary text-base-content bg-base-200" />
          </div>

           <div class="form-control mb-6">
            <label class="label text-base-content/80 font-serif">Confirm Password</label>
            <input type="password" name="user[password_confirmation]" required class="input input-bordered focus:border-primary text-base-content bg-base-200" />
          </div>

          <button type="submit" class="btn btn-primary w-full font-display uppercase tracking-widest text-primary-content">
            Sign Up
          </button>
        </form>

        <p class="text-center mt-6 text-sm text-base-content/60 font-serif">
          Already have a card? <.link navigate={~p"/sign-in"} class="text-primary hover:underline">Sign In</.link>
        </p>
      </div>
    </div>
    """
  end
end
