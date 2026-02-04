defmodule JournalWeb.AuthLive.Index do
  use JournalWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, page_title: "Sign In", trigger_submit: false)}
  end

  def handle_event("sign_in", %{"user" => params}, socket) do
    # Trigger form submission to the standard auth route
    {:noreply, assign(socket, trigger_submit: true, params: params)}
  end

  def render(assigns) do
    ~H"""
    <div class="min-h-screen flex items-center justify-center bg-base-300">
      <div class="w-full max-w-md p-8 bg-base-100 rounded-box border border-primary/20 shadow-2xl">
        <h2 class="text-3xl font-display text-primary mb-6 text-center">Midnight Library</h2>
        
        <form action="/auth/user/password/sign_in" method="post" phx-trigger-action={@trigger_submit} phx-submit="sign_in">
          <input type="hidden" name="_csrf_token" value={get_csrf_token()} />
          <input type="hidden" name="return_to" value="/journals" />
          <div class="form-control mb-4">
            <label class="label text-base-content/80 font-serif">Email</label>
            <input type="email" name="user[email]" required class="input input-bordered focus:border-primary text-base-content bg-base-200" />
          </div>
          
          <div class="form-control mb-6">
            <label class="label text-base-content/80 font-serif">Password</label>
            <input type="password" name="user[password]" required class="input input-bordered focus:border-primary text-base-content bg-base-200" />
          </div>

          <button type="submit" class="btn btn-primary w-full font-display uppercase tracking-widest text-primary-content">
            Enter
          </button>
        </form>

        <p class="text-center mt-6 text-sm text-base-content/60 font-serif">
          New here? <.link navigate={~p"/register"} class="text-primary hover:underline">Get a library card</.link>
        </p>
      </div>
    </div>
    """
  end
end
