defmodule JournalWeb.AuthHTML do
  use JournalWeb, :html

  embed_templates "auth_html/*"

  def failure(assigns) do
    ~H"""
    <div class="alert alert-error">
      <p>Something went wrong!</p>
    </div>
    """
  end
  
    def success(assigns) do
    ~H"""
    <div class="alert alert-success">
      <p>Success!</p>
    </div>
    """
  end
end
