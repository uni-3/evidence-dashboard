import { next } from "@vercel/edge";

// ページ以下はbasic認証
export const config = {
  matcher: ["/demo/:path*", "/playground/:path*"],
};

export default function middleware(request) {
  const authorizationHeader = request.headers.get("authorization");

  // 正解のユーザー/パスワード
  const validUser = process.env.BASIC_AUTH_USER;
  const validPass = process.env.BASIC_AUTH_PASSWORD;
  if (!validUser || !validPass) {
    console.error('Basic auth credentials are not set in environment variables.');
    return new Response('Internal Server Error', { status: 500 });
  }

  if (authorizationHeader) {
    try {
      const basicAuth = authorizationHeader.split(" ")[1];
      const [user, password] = atob(basicAuth).split(":");

      if (safeCompare(user, validUser) && safeCompare(password, validPass)) {
        return next();
      }
    } catch (e) {
      // Malformed auth header, fall through to the 401 response below.
    }
  }

  return new Response("Auth Required", {
    status: 401,
    headers: {
      "WWW-Authenticate": 'Basic realm="Secure Area"',
    },
  });
}

// Constant-time comparison to prevent timing attacks
const safeCompare = (a, b) => {
  let mismatch = a.length === b.length ? 0 : 1;
  if (mismatch) {
    // Ensure comparison time is not dependent on string length
    b = a;
  }
  for (let i = 0; i < a.length; ++i) {
    mismatch |= a.charCodeAt(i) ^ b.charCodeAt(i);
  }
  return mismatch === 0;
};
