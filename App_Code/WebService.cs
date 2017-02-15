// I, Bobby Filippopoulos, student number 000338236, certify that this material is my
// original work. No other person's work has been used without due
// acknowledgement and I have not made my work available to anyone else.
//
//Test Plan
//1. Statement of Authorship
//2. Name space is changed
//3. Is created as a web service
//4. XML documentation is present
//5. Accepts 2 strings, Email and Password    (ghouse@gmail.com, cuddy)
//6. Returns ID and access level in lower cases if match is found  (1,admin)
//7. If no match is found, No Access will be returned
//***************************************************************************

using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.Configuration;
using System.Data.SqlClient;

/// <summary>
/// This webservice takes and email and a password and authenticates it through the hasc database.
/// It will return a string value contatining the access level and the ID of the person signing in.
/// </summary>
[WebService(Namespace = "http://hasc.com")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]

public class WebService : System.Web.Services.WebService
{

    public WebService()
    {


    }
    /// <summary>
    /// this method will take two user inputs, an email and password. It checks if those credentials exist and will return the id and access level
    /// </summary>
    /// <param name="Email">The email of the user</param>
    /// <param name="Password">The password of the user</param>
    /// <returns>Returns a strings containing the ID and access level</returns>
    [WebMethod]
    public string validate(String Email, String Password)
    {
        String email = Email;
        String password = Password;
        Boolean usernameValid = false;
        Boolean passwordValid = false;
        String output = "";

        String con = WebConfigurationManager.ConnectionStrings["HASCConnectionString"].ConnectionString;
        String con1 = WebConfigurationManager.ConnectionStrings["HASCConnectionString"].ConnectionString;
        String con2 = WebConfigurationManager.ConnectionStrings["HASCConnectionString"].ConnectionString;
        SqlConnection db = new SqlConnection(con);
        SqlConnection db1 = new SqlConnection(con1);
        SqlConnection db2 = new SqlConnection(con2);

        SqlCommand isUserNameValid = new SqlCommand("SELECT Email FROM Persons", db);
        SqlCommand isPassValid = new SqlCommand("", db1);
        SqlCommand getString = new SqlCommand("", db2);
        try
        {


            using (db)
            {
                db.Open();
                SqlDataReader rdr = isUserNameValid.ExecuteReader();

                while ((rdr.Read()) || (usernameValid == false))
                {
                    if (email == rdr[0].ToString())
                    {
                        usernameValid = true;
                    }
                }



                db.Close();
            }

            if (usernameValid == true)
            {
                isPassValid.CommandText = "SELECT UserPassword FROM Persons WHERE Email = @Email";
                isPassValid.Parameters.AddWithValue("@Email", email);
                using (db1)
                {
                    db1.Open();
                    SqlDataReader rdr = isPassValid.ExecuteReader();
                    while (rdr.Read())
                    {
                        if (password == rdr[0].ToString())
                        {
                            passwordValid = true;
                        }
                        else
                        {
                            output = "No Access";
                        }
                    }

                    db1.Close();
                }

            }
            else
            {
                output = "No Access";
            }

            if ((passwordValid == true) && (usernameValid == true))
            {
                getString.CommandText = "SELECT PersonID, Administrator, Player, Referee, Coach FROM Persons WHERE Email = @Email";
                getString.Parameters.AddWithValue("@Email", email);
                using (db2)
                {
                    db2.Open();
                    SqlDataReader read = getString.ExecuteReader();

                    while (read.Read())
                    {
                        if (read[1].ToString() == "True")
                        {
                            output = read[0].ToString() + ",admin";
                        }
                        if (read[2].ToString() == "True")
                        {
                            output = read[0].ToString() + ",player";
                        }
                        if (read[3].ToString() == "True")
                        {
                            output = read[0].ToString() + ",referee";
                        }
                        if (read[4].ToString() == "True")
                        {
                            output = read[0].ToString() + ",coach";
                        }

                    }
                }

            }
        }
        catch (Exception ex)
        {
            output = "No Access";
        }
        return output;
    }
}
